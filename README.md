# LBImageCarouselView 图片轮播器
图片轮播器，只要一句代码就可以创建一个轮播器，可以自定义轮播器大小  
用Collection实现，支持自定义轮播页Cell 


属性：  

      用来设置cell类型的block  
      
      typedef void(^sendBlock)(id cell,id model);  
      
      
      @interface LBImageCarouselView : UICollectionView  
      
      用来设置自定义的cell的model，必须实现此block否则无法正常显示cell  
      
      @property(nonatomic,copy) sendBlock setCellModelBlock;  
      
      你可以在父控件中设置好pageControl的frame，color等属性，然后将其传给此属性即可实现pageControl跟随滚动显示的效果  
      
      @property(nonatomic,strong) UIPageControl *pageControl;  
      
      用来设置定时器的滚动速度  
      
      @property (nonatomic,assign) NSTimeInterval timeInterval;  
      
      
      用来创建轮播器的初始化方法  
      
      参数：  
      
      modelArray: 装cell模型的数组  
      
      cellClassName: 自定义的cell的类名  
      
      cellType: 用何种方式自定义的cell  
      
      timeInterval: 自动翻页的速度，每timeInterval秒翻动一次  
      
     
     > - (instancetype)initWithFrame:(CGRect)frame AndWithModelArray:(NSArray *)modelArray AndWithClassNameOfCell:(NSString *)cellClassName AndWithCellType:(LBCellType)cellType AndWithTimeInterval:(NSTimeInterval)timeInterval;  
 - 
