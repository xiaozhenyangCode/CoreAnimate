//
//  FileFormatViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/10/12.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 文件格式
 图片加载性能取决于加载大图的时间和解压小图时间的权衡。很多苹果的文档都说PNG是iOS所有图片加载的最好格式。但这是极度误导的过时信息了。

 PNG图片使用的无损压缩算法可以比使用JPEG的图片做到更快地解压，但是由于闪存访问的原因，这些加载的时间并没有什么区别。

 展示了标准的应用程序加载不同尺寸图片所需要时间的一些代码。为了保证实验的准确性，我们会测量每张图片的加载和绘制时间来确保考虑到解压性能的因素。另外每隔一秒重复加载和绘制图片，这样就可以取到平均时间，使得结果更加准确。

 PNG和JPEG压缩算法作用于两种不同的图片类型：JPEG对于噪点大的图片效果很好；但是PNG更适合于扁平颜色，锋利的线条或者一些渐变色的图片。为了让测评的基准更加公平，我们用一些不同的图片来做实验：一张照片和一张彩虹色的渐变。JPEG版本的图片都用默认的Photoshop60%“高质量”设置编码。

 如结果所示，相对于不友好的PNG图片，相同像素的JPEG图片总是比PNG加载更快，除非一些非常小的图片、但对于友好的PNG图片，一些中大尺寸的图效果还是很好的。

 所以对于之前的图片传送器程序来说，JPEG会是个不错的选择。如果用JPEG的话，一些多线程和缓存策略都没必要了。

 但JPEG图片并不是所有情况都适用。如果图片需要一些透明效果，或者压缩之后细节损耗很多，那就该考虑用别的格式了。苹果在iOS系统中对PNG和JPEG都做了一些优化，所以普通情况下都应该用这种格式。也就是说在一些特殊的情况下才应该使用别的格式。

 */
class FileFormatViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    var items = [String]()
    var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundlePath = Bundle.main.path(forResource: "Vacation", ofType: "")
        do {
            let filesArray = try FileManager.default.contentsOfDirectory(atPath: bundlePath ?? "")
            for file in filesArray {
                items.append(bundlePath! + "/" + file)
            }
        } catch {
        }
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.rowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    func loadImageForOneSec(_ path: String) -> CFTimeInterval {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        var imagesLoaded: Double = 0
        var endTime: CFTimeInterval = 0
        let startTime = CFAbsoluteTimeGetCurrent()
        while endTime - startTime < 1 {
            let image = UIImage(contentsOfFile: path)
            image?.draw(at: .zero)
            imagesLoaded += 1
            endTime = CFAbsoluteTimeGetCurrent()
        }
        UIGraphicsEndImageContext()
        return (endTime - startTime) / imagesLoaded
    }

    func loadImageAtIndex(_ index: Int) {
        DispatchQueue.global().async {
            let path = self.items[index]
            let pngTime = self.loadImageForOneSec(path) * 1000
            DispatchQueue.main.async {
                let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0))
                cell?.detailTextLabel?.text = "PNG :" + "\(pngTime.roundTo(places: 3))ms"
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = String(items[indexPath.row].suffix(5))
        cell?.detailTextLabel?.text = "Loading..."
        loadImageAtIndex(indexPath.row)
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ctrl = PNGFileFormatViewController()
        navigationController?.pushViewController(ctrl, animated: true)
    }
}

/**

 混合图片

 对于包含透明的图片来说，最好是使用压缩透明通道的PNG图片和压缩RGB部分的JPEG图片混合起来加载。这就对任何格式都适用了，而且无论从质量还是文件尺寸还是加载性能来说都和PNG和JPEG的图片相近。相关分别加载颜色和遮罩图片并在运行时合成的代码。
 #import "ViewController.h"
 @interface ViewController ()
 @property (nonatomic, weak) IBOutlet UIImageView *imageView;
 @end
 @implementation ViewController
 - (void)viewDidLoad
 {
     [super viewDidLoad];
     //load color image
     UIImage *image = [UIImage imageNamed:@"Snowman.jpg"];
     //load mask image
     UIImage *mask = [UIImage imageNamed:@"SnowmanMask.png"];
     //convert mask to correct format
     CGColorSpaceRef graySpace = CGColorSpaceCreateDeviceGray();
     CGImageRef maskRef = CGImageCreateCopyWithColorSpace(mask.CGImage, graySpace);
     CGColorSpaceRelease(graySpace);
     //combine images
     CGImageRef resultRef = CGImageCreateWithMask(image.CGImage, maskRef);
     UIImage *result = [UIImage imageWithCGImage:resultRef];
     CGImageRelease(resultRef);
     CGImageRelease(maskRef);
     //display result
     self.imageView.image = result;
 }
 @end
 对每张图片都使用两个独立的文件确实有些累赘。JPNG的库（https://github.com/nicklockwood/JPNG）对这个技术提供了一个开源的可以复用的实现，并且添加了直接使用+imageNamed:和+imageWithContentsOfFile:方法的支持。

JPEG 2000

   除了JPEG和PNG之外iOS还支持别的一些格式，例如TIFF和GIF，但是由于他们质量压缩得更厉害，性能比JPEG和PNG糟糕的多，所以大多数情况并不用考虑。

   但是iOS之后，苹果低调添加了对JPEG 2000图片格式的支持，所以大多数人并不知道。它甚至并不被Xcode很好的支持 - JPEG 2000图片都没在Interface Builder中显示。

   但是JPEG 2000图片在（设备和模拟器）运行时会有效，而且比JPEG质量更好，同样也对透明通道有很好的支持。但是JPEG 2000图片在加载和显示图片方面明显要比PNG和JPEG慢得多，所以对图片大小比运行效率更敏感的时候，使用它是一个不错的选择。

   但仍然要对JPEG 2000保持关注，因为在后续iOS版本说不定就对它的性能做提升，但是在现阶段，混合图片对更小尺寸和质量的文件性能会更好。

PVRTC

   当前市场的每个iOS设备都使用了Imagination Technologies PowerVR图像芯片作为GPU。PowerVR芯片支持一种叫做PVRTC（PowerVR Texture Compression）的标准图片压缩。

   和iOS上可用的大多数图片格式不同，PVRTC不用提前解压就可以被直接绘制到屏幕上。这意味着在加载图片之后不需要有解压操作，所以内存中的图片比其他图片格式大大减少了（这取决于压缩设置，大概只有1/60那么大）。

   但是PVRTC仍然有一些弊端：

尽管加载的时候消耗了更少的RAM，PVRTC文件比JPEG要大，有时候甚至比PNG还要大（这取决于具体内容），因为压缩算法是针对于性能，而不是文件尺寸。

PVRTC必须要是二维正方形，如果源图片不满足这些要求，那必须要在转换成PVRTC的时候强制拉伸或者填充空白空间。

质量并不是很好，尤其是透明图片。通常看起来更像严重压缩的JPEG文件。

PVRTC不能用Core Graphics绘制，也不能在普通的UIImageView显示，也不能直接用作图层的内容。你必须要用作OpenGL纹理加载PVRTC图片，然后映射到一对三角板来在CAEAGLLayer或者GLKView中显示。

创建一个OpenGL纹理来绘制PVRTC图片的开销相当昂贵。除非你想把所有图片绘制到一个相同的上下文，不然这完全不能发挥PVRTC的优势。

PVRTC使用了一个不对称的压缩算法。尽管它几乎立即解压，但是压缩过程相当漫长。在一个现代快速的桌面Mac电脑上，它甚至要消耗一分钟甚至更多来生成一个PVRTC大图。因此在iOS设备上最好不要实时生成。

   如果你愿意使用OpehGL，而且即使提前生成图片也能忍受得了，那么PVRTC将会提供相对于别的可用格式来说非常高效的加载性能。比如，可以在主线程1/60秒之内加载并显示一张2048×2048的PVRTC图片（这已经足够大来填充一个视网膜屏幕的iPad了），这就避免了很多使用线程或者缓存等等复杂的技术难度。

   Xcode包含了一些命令行工具例如texturetool来生成PVRTC图片，但是用起来很不方便（它存在于Xcode应用程序束中），而且很受限制。一个更好的方案就是使用Imagination Technologies PVRTexTool，可以从http://www.imgtec.com/powervr/insider/sdkdownloads免费获得。

   安装了PVRTexTool之后，就可以使用如下命令在终端中把一个合适大小的PNG图片转换成PVRTC文件：
 /Applications/Imagination/PowerVR/GraphicsSDK/PVRTexTool/CL/OSX_x86/PVRTexToolCL -i {input_file_name}.png -o {output_file_name}.pvr -legacypvr -p -f PVRTC1_4 -q pvrtcbest
 
 加载和显示PVRTC图片
 #import "ViewController.h"
 #import <QuartzCore/QuartzCore.h>
 #import <GLKit/GLKit.h>
 @interface ViewController ()
 @property (nonatomic, weak) IBOutlet UIView *glView;
 @property (nonatomic, strong) EAGLContext *glContext;
 @property (nonatomic, strong) CAEAGLLayer *glLayer;
 @property (nonatomic, assign) GLuint framebuffer;
 @property (nonatomic, assign) GLuint colorRenderbuffer;
 @property (nonatomic, assign) GLint framebufferWidth;
 @property (nonatomic, assign) GLint framebufferHeight;
 @property (nonatomic, strong) GLKBaseEffect *effect;
 @property (nonatomic, strong) GLKTextureInfo *textureInfo;
 @end
 @implementation ViewController
 - (void)setUpBuffers
 {
     //set up frame buffer
     glGenFramebuffers(1, &_framebuffer);
     glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
     //set up color render buffer
     glGenRenderbuffers(1, &_colorRenderbuffer);
     glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
     glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);
     [self.glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer];
     glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_framebufferWidth);
     glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_framebufferHeight);
     //check success
     if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
         NSLog(@"Failed to make complete framebuffer object: %i", glCheckFramebufferStatus(GL_FRAMEBUFFER));
     }
 }
 - (void)tearDownBuffers
 {
     if (_framebuffer) {
         //delete framebuffer
         glDeleteFramebuffers(1, &_framebuffer);
         _framebuffer = 0;
     }
     if (_colorRenderbuffer) {
         //delete color render buffer
         glDeleteRenderbuffers(1, &_colorRenderbuffer);
         _colorRenderbuffer = 0;
     }
 }
 - (void)drawFrame
 {
     //bind framebuffer & set viewport
     glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
     glViewport(0, 0, _framebufferWidth, _framebufferHeight);
     //bind shader program
     [self.effect prepareToDraw];
     //clear the screen
     glClear(GL_COLOR_BUFFER_BIT);
     glClearColor(0.0, 0.0, 0.0, 0.0);
     //set up vertices
     GLfloat vertices[] = {
         -1.0f, -1.0f, -1.0f, 1.0f, 1.0f, 1.0f, 1.0f, -1.0f
     };
     //set up colors
     GLfloat texCoords[] = {
         0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f, 1.0f, 1.0f
     };
     //draw triangle
     glEnableVertexAttribArray(GLKVertexAttribPosition);
     glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
     glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
     glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
     glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
     //present render buffer
     glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
     [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
 }
 - (void)viewDidLoad
 {
     [super viewDidLoad];
     //set up context
     self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
     [EAGLContext setCurrentContext:self.glContext];
     //set up layer
     self.glLayer = [CAEAGLLayer layer];
     self.glLayer.frame = self.glView.bounds;
     self.glLayer.opaque = NO;
     [self.glView.layer addSublayer:self.glLayer];
     self.glLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @NO, kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};
     //load texture
     glActiveTexture(GL_TEXTURE0);
     NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"Snowman" ofType:@"pvr"];
     self.textureInfo = [GLKTextureLoader textureWithContentsOfFile:imageFile options:nil error:NULL];
     //create texture
     GLKEffectPropertyTexture *texture = [[GLKEffectPropertyTexture alloc] init];
     texture.enabled = YES;
     texture.envMode = GLKTextureEnvModeDecal;
     texture.name = self.textureInfo.name;
     //set up base effect
     self.effect = [[GLKBaseEffect alloc] init];
     self.effect.texture2d0.name = texture.name;
     //set up buffers
     [self setUpBuffers];
     //draw frame
     [self drawFrame];
 }
 - (void)viewDidUnload
 {
     [self tearDownBuffers];
     [super viewDidUnload];
 }
 - (void)dealloc
 {
     [self tearDownBuffers];
     [EAGLContext setCurrentContext:nil];
 }
 @end
 如你所见，非常不容易，如果你对在常规应用中使用PVRTC图片很感兴趣的话（例如基于OpenGL的游戏），可以参考一下GLView的库（https://github.com/nicklockwood/GLView），它提供了一个简单的GLImageView类，重新实现了UIImageView的各种功能，但同时提供了PVRTC图片，而不需要你写任何OpenGL代码。
 */
class PNGFileFormatViewController: BaseViewController {
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PNGFileFormatViewController"

        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
        view.addSubview(imageView)
        imageView.center = view.center

        let image = UIImage(named: "snowman")

        let mask = UIImage(named: "SnowmanMask")

        let graySpace = CGColorSpaceCreateDeviceGray()
    }
}

extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
