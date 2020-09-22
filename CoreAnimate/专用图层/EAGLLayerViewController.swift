//
//  EAGLLayerViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/21.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 CAEAGLLayer
 当iOS要处理高性能图形绘制，必要时就是OpenGL。应该说它应该是最后的杀手锏，至少对于非游戏的应用来说是的。因为相比Core Animation和UIkit框架，它不可思议地复杂。

 OpenGL提供了Core Animation的基础，它是底层的C接口，直接和iPhone，iPad的硬件通信，极少地抽象出来的方法。OpenGL没有对象或是图层的继承概念。它只是简单地处理三角形。OpenGL中所有东西都是3D空间中有颜色和纹理的三角形。用起来非常复杂和强大，但是用OpenGL绘制iOS用户界面就需要很多很多的工作了。

 为了能够以高性能使用Core Animation，你需要判断你需要绘制哪种内容（矢量图形，例子，文本，等等），但后选择合适的图层去呈现这些内容，Core Animation中只有一些类型的内容是被高度优化的；所以如果你想绘制的东西并不能找到标准的图层类，想要得到高性能就比较费事情了。
 因为OpenGL根本不会对你的内容进行假设，它能够绘制得相当快。利用OpenGL，你可以绘制任何你知道必要的集合信息和形状逻辑的内容。所以很多游戏都喜欢用OpenGL（这些情况下，Core Animation的限制就明显了：它优化过的内容类型并不一定能满足需求），但是这样依赖，方便的高度抽象接口就没了。
 在iOS5中，苹果引入了一个新的框架叫做GLKit，它去掉了一些设置OpenGL的复杂性，提供了一个叫做CLKView的UIView的子类，帮你处理大部分的设置和绘制工作。前提是各种各样的OpenGL绘图缓冲的底层可配置项仍然需要你用CAEAGLLayer完成，它是CALayer的一个子类，用来显示任意的OpenGL图形。
 大部分情况下你都不需要手动设置CAEAGLLayer（假设用GLKView），过去的日子就不要再提了。特别的，我们将设置一个OpenGL ES 2.0的上下文，它是现代的iOS设备的标准做法。
 尽管不需要GLKit也可以做到这一切，但是GLKit囊括了很多额外的工作，比如设置顶点和片段着色器，这些都以类C语言叫做GLSL自包含在程序中，同时在运行时载入到图形硬件中。编写GLSL代码和设置EAGLayer没有什么关系，所以我们将用GLKBaseEffect类将着色逻辑抽象出来。其他的事情，我们还是会有以往的方式。

 在一个真正的OpenGL应用中，我们可能会用NSTimer或CADisplayLink周期性地每秒钟调用-drawRrame方法60次，同时会将几何图形生成和绘制分开以便不会每次都重新生成三角形的顶点（这样也可以让我们绘制其他的一些东西而不是一个三角形而已），不过上面这个例子已经足够演示了绘图原则了。
 */
class EAGLLayerViewController: BaseViewController {
    var glView: UIView!
    var glContext: EAGLContext!
    var glLayer: CAEAGLLayer!
    var frameBuffer = GLuint()
    var colorRenderbuffer = GLuint()
    var framebufferWidth = GLint()
    var framebufferHeight = GLint()
    var effect: GLKBaseEffect!

    override func viewDidLoad() {
        super.viewDidLoad()

        glView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.addSubview(glView)
        glView.center = view.center

        glContext = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(glContext)

        glLayer = CAEAGLLayer()
        glLayer.frame = glView.bounds
        glView.layer.addSublayer(glLayer)
        glLayer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking: "NO", kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8]

        effect = GLKBaseEffect()

        setUpBuffers()

        drawFrame()
    }

    func setUpBuffers() {
        glGenFramebuffers(1, &frameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)

        glGenRenderbuffers(1, &colorRenderbuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderbuffer)
        
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), colorRenderbuffer)
        glContext.renderbufferStorage(Int(GL_RENDERBUFFER), from: glLayer)
        
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &framebufferWidth)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &framebufferHeight)

        if glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)) != GL_FRAMEBUFFER_COMPLETE {
            printf("Failed to make complete framebuffer object \(glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)))")
        }
    }

    func drawFrame() {
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
        glViewport(0, 0, framebufferWidth, framebufferHeight)

        effect.prepareToDraw()

        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        glClearColor(0, 0, 0, 1)

        let vertices = [-0.5, -0.5, -1.0, 0.0, 0.5, -1.0, 0.5, -0.5, -1.0]

        let colors = [0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 0.0, 1.0]

        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.color.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, vertices)
        glVertexAttribPointer(GLuint(GLKVertexAttrib.color.rawValue), 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, colors)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)

        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderbuffer)
        glContext.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }

    func tearDownBuffers() {
        glDeleteFramebuffers(1, &frameBuffer)
        frameBuffer = 0
        glDeleteRenderbuffers(1, &colorRenderbuffer)
        colorRenderbuffer = 0
    }

    deinit {
        tearDownBuffers()
        EAGLContext.setCurrent(nil)
    }
}
