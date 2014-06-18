//
//  Shader.fsh
//  Chess
//
//  Created by Liu Di on 6/13/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
