//
//  Shader.fsh
//  iOS
//
//  Created by Robby on 9/19/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
