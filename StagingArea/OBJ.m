#import "OBJ.h"
#import <OpenGLES/ES1/gl.h>
#import "tiny_obj_loader.h"

@interface OBJ (){
    std::vector<tinyobj::shape_t> shapes;
}

@end

@implementation OBJ

-(id)initWithOBJ:(NSString *)file Path:(NSString *)path{
    self = [super init];
    if(self){
        [self loadOBJ:file Path:path];
    }
    return self;
}

-(void)draw{
    if(shapes.size()){
        glColor4f(0.0, 0.0, 0.0, 1.0);
//        [self drawOBJPoints];
        [self drawOBJTriangles];
    }
}

-(void) drawOBJPoints{
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, &shapes[0].mesh.positions[0]);
    glDrawArrays(GL_POINTS, 0, shapes[0].mesh.positions.size());
    glDisableClientState(GL_VERTEX_ARRAY);
}

-(void)drawOBJTriangles{
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    for(int i = 0; i < shapes.size(); i++){
        glVertexPointer(3, GL_FLOAT, 0, &(shapes[i].mesh.positions[0]));
        if(shapes[i].mesh.normals.size())
            glNormalPointer(GL_FLOAT, 0, &(shapes[i].mesh.normals[0]));
        int numFaces = shapes[i].mesh.indices.size()/3.0;
        glDrawElements(GL_TRIANGLES, numFaces*3, GL_UNSIGNED_SHORT, &(shapes[0].mesh.indices[0]));
    }
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_VERTEX_ARRAY);
}

-(void) loadOBJ:(NSString*)filename Path:(NSString*)directory{
    directory = [directory stringByAppendingString:@"/"];
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    std::string err = tinyobj::LoadObj(shapes, [file cStringUsingEncoding:NSUTF8StringEncoding], [directory cStringUsingEncoding:NSUTF8StringEncoding]);
//    if (!err.empty())
//        std::cerr << err << std::endl;
    // don't use this
//    for( int i = 0; i < shapes.size(); i++)
//        if(!shapes[i].mesh.normals.size())
//            [self fakeOBJNormals:i];
}

@end
