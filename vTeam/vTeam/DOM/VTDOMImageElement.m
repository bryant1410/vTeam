//
//  VTDOMImageElement.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMImageElement.h"

#import "VTDOMElement+Render.h"
#import "VTDOMElement+Style.h"
#import "VTDOMDocument.h"

#import <QuartzCore/QuartzCore.h>

@interface VTDOMImageElement()


@end

@implementation VTDOMImageElement

@synthesize image = _image;

@synthesize source = _source;
@synthesize loading = _loading;
@synthesize defaultImage = _defaultImage;
@synthesize loaded = _loaded;

-(void) dealloc{
    [_defaultImage release];
    [_image release];
    [super dealloc];
}

-(UIImage *) image{
    if(_image == nil){
        self.image = [self imageValueForKey:@"src" bundle:self.document.bundle];
    }
    return _image;
}

-(UIImage *) defaultImage{
    if(_defaultImage == nil){
        self.defaultImage = [self imageValueForKey:@"defaultSrc" bundle:self.document.bundle];
    }
    return _defaultImage;
}

-(NSString *) src{
    return [self attributeValueForKey:@"src"];
}

-(void) setSrc:(NSString *)src{
    [self setAttributeValue:src forKey:@"src"];
    _loaded = NO;
    _loading = NO;
    self.image = nil;
}

-(NSString *) defaultSrc{
    return [self attributeValueForKey:@"defaultSrc"];
}

-(void) setDefaultSrc:(NSString *)defaultSrc{
    [self setAttributeValue:defaultSrc forKey:@"defaultSrc"];
}

-(void) setImage:(UIImage *) image isLocal:(BOOL) isLocal{
    
    if(image == nil){
        if(!isLocal){
            self.loaded = YES;
        }
    }
    else{
        self.loaded = YES;
    }
    
    self.image = image;
    
    if(image){
        
        if([self attributeValueForKey:@"fit-width"]){
            
            CGRect r = [self frame];
            
            CGSize imageSize = [image size];
            
            if(r.size.width && r.size.height && imageSize.width && imageSize.height){
                
                if(r.size.width / r.size.height != imageSize.width / imageSize.height){
                    r.size.width = imageSize.width / imageSize.height * r.size.height;
                    
                    [self setFrame:r];
                }
                
            }
            
        }
        
        if([self attributeValueForKey:@"fit-height"]){
            
            CGRect r = [self frame];
            
            CGSize imageSize = [image size];
            
            if(r.size.width && r.size.height && imageSize.width && imageSize.height){
                
                if(r.size.width / r.size.height != imageSize.width / imageSize.height){
                    
                    r.size.height = imageSize.height / imageSize.width * r.size.width;
                    
                    [self setFrame:r];
                }
                
            }
            
        }
    }
    
    [self performSelector:@selector(setNeedDisplay) withObject:nil afterDelay:0.0];
    
}

-(void) draw:(CGRect) rect context:(CGContextRef) context{
    
    [super draw:rect context:context];
    
    CGSize size = self.frame.size;
    CGRect r = CGRectMake(0, 0, size.width, size.height);
    
    UIImage * image = [self image];
    
    if(image == nil){
        image = [self defaultImage];
    }
    
    if(image ){
        
        CALayer * layer = [self layer];
        layer.frame = r;
        layer.contents = (id)[image CGImage];
        layer.contentsRect = CGRectMake(0, 0, 1.0, 1.0);
        layer.contentsCenter = CGRectMake(0, 0, 1, 1);
        
        CGSize imageSize = [image size];
        CGFloat leftCapWidth = [image leftCapWidth];
        CGFloat topCapHeight = [image topCapHeight];
        
        if(leftCapWidth || topCapHeight){
            
            leftCapWidth = leftCapWidth / imageSize.width;
            topCapHeight = topCapHeight / imageSize.height;
            
            layer.contentsCenter = CGRectMake(leftCapWidth, topCapHeight, 1.0 / imageSize.width , 1.0 / imageSize.height);
        }
        
        NSString * gravity = [self stringValueForKey:@"gravity"];
        
        if([gravity isEqualToString:@"center"]){
            layer.contentsGravity = kCAGravityCenter;
        }
        else if([gravity isEqualToString:@"resize"]){
            layer.contentsGravity = kCAGravityResize;
        }
        else if([gravity isEqualToString:@"top"]){
            layer.contentsGravity = kCAGravityTop;
        }
        else if([gravity isEqualToString:@"bottom"]){
            layer.contentsGravity = kCAGravityBottom;
        }
        else if([gravity isEqualToString:@"left"]){
            layer.contentsGravity = kCAGravityLeft;
        }
        else if([gravity isEqualToString:@"right"]){
            layer.contentsGravity = kCAGravityRight;
        }
        else if([gravity isEqualToString:@"topleft"]){
            layer.contentsGravity = kCAGravityTopLeft;
        }
        else if([gravity isEqualToString:@"topright"]){
            layer.contentsGravity = kCAGravityTopRight;
        }
        else if([gravity isEqualToString:@"bottomleft"]){
            layer.contentsGravity = kCAGravityBottomLeft;
        }
        else if([gravity isEqualToString:@"bottomright"]){
            layer.contentsGravity = kCAGravityBottomRight;
        }
        else if([gravity isEqualToString:@"aspect"]){
            layer.contentsGravity = kCAGravityResizeAspect;
        }
        else{
            layer.contentsGravity = kCAGravityResizeAspectFill;
        }
    
        [layer renderInContext:context];
    }
    
}

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    CGRect r = [self frame];
    
    if(r.size.width == MAXFLOAT || r.size.height == MAXFLOAT){
        
        UIImage * image = [self image];
        
        if(image){
            
            CGSize s = image.size;
            
            if(r.size.width == MAXFLOAT){
                r.size.width = s.width;
            }
            
            if(r.size.height == MAXFLOAT){
                r.size.height = s.height;
            }

        }
        else{
            if(r.size.width == MAXFLOAT){
                r.size.width = 0;
            }
            
            if(r.size.height == MAXFLOAT){
                r.size.height = 0;
            }
        }
       
        [self setFrame:r];
        
    }
    return r.size;
}

@end
