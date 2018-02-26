# timerdemo
在项目里，难免要使用到定时器NSTimer，如果稍微不留意，特别容易造成循环引用。以前的解决方案过于笨拙，现在又对以前的防止循环引用的方法进行了进一步的修改，更符合代码的可维护性。

#造成NSTimer循环引用问题的原因
```
@interface TimerViewController ()
@property (nonatomic,strong)NSTimer * timer;
@end

self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];

```
我们在声明timer属性的时候，使用strong去修饰，那么self就强引用了timer这个属性，在使用timer的时候target又指向self ，timer又强引用了self。这样就造成了循环引用。所以在使用timer的时候，要特别小心留意，如果不解决循环引用问题，后续会造成特别多的内存泄露，连锁反应造成更坏的影响。

#以往笨拙的解决方案
以往的解决思路是在控制器消失的时候 关闭计时器
```
-(void)viewDidDisappear:(BOOL)animated{
[super viewDidDisappear:animated];
[self.timer invalidate];
self.timer = nil;
}
```
在控制器出现时候 启动计时器
```
-(void)viewDidAppear:(BOOL)animated{
[super viewDidAppear:animated];
self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}
```
但是这样过于繁琐，上面的代码只是一个过程说明，根据业务逻辑可能要做大量的状态判断来控制timer的启动和关闭。由于以前项目的时间问题，采用了这种笨拙且不符合代码规范的写法，如果使用这种方法到后期代码维护阶段，特别难拆分和进一步维护。

#思考之后优化的解决方案
```
@interface NSTimer (LMBlockSupport)

+ (NSTimer *)lm_scheduledTimerWithTimeInterval:(NSTimeInterval)time
block:(void(^)(void))block
repeats:(BOOL)repeats;

@end

@implementation NSTimer (LMBlockSupport)

+ (NSTimer *)lm_scheduledTimerWithTimeInterval:(NSTimeInterval)time
block:(void(^)(void))block
repeats:(BOOL)repeats{

return [self scheduledTimerWithTimeInterval:time
target:self
selector:@selector(lm_blockInvoke:)
userInfo:[block copy]
repeats:repeats];
}

+ (void)lm_blockInvoke:(NSTimer *)timer{

void(^block)(void) = timer.userInfo;
if (block) {
block();
}
}

@end

```
对NSTimer添加一个分类，在分类内添加一个新的类方法。类方法有一个类型为block的参数（定义的block位于栈上，为了防止块被释放，需要调用copy方法，将块移到堆上）。使用这个类别的方式如下：
```
__weak TimerViewController *weakSelf = self;
self.timer = [NSTimer lm_scheduledTimerWithTimeInterval:1.0 block:^{
__strong TimerViewController *strongSelf = weakSelf;
[strongSelf timerAction];
} repeats:YES];

[self.timer fire];
```
这个方案，就打破了self 和 timer之间的循环引用关系。
__strong TimerViewController *strongSelf = weakSelf主要是为了防止执行块的代码时，类被释放了。
在类的dealloc方法中，记得调用：
```
-(void)dealloc{

//在dealloc方法内记得关闭计时器
[self.timer invalidate];
self.timer = nil;

}
```
#既然是相互的强引用 是不是在target的时候 使用weakself 就可以解决循环引用问题了吧？

这个疑问最初就在我脑子里闪过了一下，但是当你看这个API的属性定义：其中target的说明The object to which to send the message specified by aSelector when the timer fires. The timer maintains a strong reference to this object until it (the timer) is invalidated。就是要强引用这个target。大概是这样的, __strong strongSelf = wself 强引用了一个弱引用的变量,结果还是强引用,也就是说strongSelf持有了wself所指向的对象(也即是self所只有的对象),这和你直接传self进来是一样的效果,并不能达到解除强引用的作用。


