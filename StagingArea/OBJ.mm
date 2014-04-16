//
//  OBJ.m
//  StagingArea
//
//  Created by Robby on 4/13/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//
#import "OBJ.h"

#import <OpenGLES/ES1/gl.h>
#import "tiny_obj_loader.h"
#import "GeodesicMesh.h"
#import "Geodesic.h"

@interface OBJ (){
    std::vector<tinyobj::shape_t> shapes;
    GeodesicMesh *polyhedron;
    Geodesic *geodesic;
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

-(id)initWithGeodesic:(int)type Frequency:(int)v{
    self = [super init];
    if(self){
        geodesic = new Geodesic();
        polyhedron = new GeodesicMesh();
        if(v < 1) v = 1;
        if(type == 0)
            geodesic->tetrahedron(v);
        else if(type == 1)
            geodesic->octahedron(v);
        else
            geodesic->icosahedron(v);
        polyhedron->load(geodesic);
    }
    return self;
}

-(void)draw{
    if(shapes.size()){
        glColor4f(0.0, 0.0, 0.0, 1.0);
//        [self drawOBJPoints];
        [self drawOBJTriangles];
    }
    if(polyhedron != nil){
        polyhedron->draw();//ExtrudedTriangles();
//        polyhedron->drawFaceNormalLines();
//        polyhedron->drawNormalLines();
//        polyhedron->drawPoints();
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
    if (!err.empty())
        std::cerr << err << std::endl;
    // don't use this
//    for( int i = 0; i < shapes.size(); i++)
//        if(!shapes[i].mesh.normals.size())
//            [self fakeOBJNormals:i];
}

-(void)fakeOBJNormals:(int)index{
    if(shapes[index].mesh.positions.size()){
        int numPoints = shapes[index].mesh.positions.size()/3.0;
        float length;
        for(int i = 0; i < numPoints; i++){
            length = sqrtf( pow(shapes[index].mesh.positions[X+3*i],2) + pow(shapes[index].mesh.positions[Y+3*i],2) + pow(shapes[index].mesh.positions[Z+3*i],2) );
            shapes[index].mesh.normals.push_back( shapes[index].mesh.positions[X+3*i] / length );
            shapes[index].mesh.normals.push_back( shapes[index].mesh.positions[Y+3*i] / length );
            shapes[index].mesh.normals.push_back( shapes[index].mesh.positions[Z+3*i] / length );
        }
    }
}

-(void)loadRandomGeodesic{
    if(arc4random()%3 == 0)
        geodesic->tetrahedron(arc4random()%12+1);
    else if(arc4random()%2 == 0)
        geodesic->octahedron(arc4random()%12+1);
    else
        geodesic->icosahedron(arc4random()%12+1);
    polyhedron->load(geodesic);
}

// GEODESIC on stage

-(NSString*)exportOBJ{
    char *obj;
    int length = 0;
    geodesic->OBJ(obj, length);
    NSString *objString = [NSString stringWithUTF8String:obj];
//    NSLog(@"OBJ (%d)\n%@",length,objString);
//    delete obj;
    return objString;
}

@end
