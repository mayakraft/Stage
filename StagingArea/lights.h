#ifndef __StagingArea__Lights__
#define __StagingArea__Lights__

void rainbow(float *clearColor, float *brightness, float *alpha);
void spotlightNoir(float *clearColor, float *brightness, float *alpha);
void silhouette(float *clearColor);
void whiteSilhouette(float *clearColor);

void reset_lighting();
    
#endif /* defined(__StagingArea__Lights__) */
