//
//  Recognizer.m
//  NeuralDigit
//
//  Created by yasu on 2014/10/19.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "Recognizer.h"
#define ROW 7
#define COL 7
#define IN ROW*COL
#define HID 100
#define OUT 10
#define DATA_NUM 10
#define E 2.71828183
#define alpha 0.2
#define beta 0.2

@interface Recognizer()
{
    double **W; // input - hidden layer weights
    double **V; // hidden - output layer weights
    double H[HID], O[OUT], delta[OUT], sigma[HID];
    double hid_sikii[HID];
    double out_sikii[OUT];
}
@end


@implementation Recognizer


int traning[DATA_NUM][IN] = {
    {0,0,1,1,1,0,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1,1,1,0,0,},
    {0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,0,0,},
    {0,0,1,1,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,1,0,},
    {0,0,1,1,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1,1,1,0,0,},
    {0,0,0,0,1,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,1,0,0,0,0,0,1,0,0,0,0,0,},
    {0,1,1,1,1,1,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1,1,1,0,0,},
    {0,0,1,1,1,0,0,0,1,0,0,0,1,0,0,1,0,0,0,0,0,0,1,1,1,1,0,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1,1,1,0,0,},
    {0,1,1,1,1,1,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,},
    {0,0,1,1,1,0,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1,1,1,0,0,},
    {0,0,1,1,1,0,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1,1,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,1,1,0,0,},
};

int teacher[DATA_NUM] = {'0','1','2','3','4','5','6','7','8','9'};
int digiter[OUT] = {'0','1','2','3','4','5','6','7','8','9'};//,':',';','<'};

- (void)initialize
{
    W = (double **)malloc(sizeof(double *) * IN);
    for (int i=0;i<IN;i++) {
        W[i] = (double *)malloc(sizeof(double) * HID);
    }
    V = (double **)malloc(sizeof(double *) * HID);
    for (int i=0;i<HID;i++) {
        V[i] = (double *)malloc(sizeof(double) * OUT);
    }
    
    int ran;
    srand(time(NULL));
    
    for(int i=0;i<IN;i++){
        for(int j=0;j<HID;j++){
            ran = rand()%200;
            W[i][j] = ran / 100.0 -1;
        }
    }
    for(int j=0;j<HID;j++){
        for(int k=0;k<OUT;k++){
            ran = rand()%200;
            V[j][k] =  ran / 100.0 -1;
        }
    }
    for(int j=0;j<HID;j++){
        ran = rand()%200;
        hid_sikii[j]  = ran / 100.0 -1;
    }
    for(int k=0;k<OUT;k++){
        ran = rand()%200;
        out_sikii[k]  = ran / 100.0 -1;
    }
}

double sigmoid(double x){
    return 1.0 / (1.0+pow(E,-x));
}

- (void)train
{
    int i,j,k;
    int tra = 0;
    int loop = 40000;
    double buf;
    
    while(loop--){
        for(j=0;j<HID;j++){
            buf = 0;
            for(i=0;i<IN;i++){
                buf += W[i][j]*traning[tra][i];
            }
            
            H[j] = sigmoid(buf+hid_sikii[j]);
        }
        
        for(k=0;k<OUT;k++){
            buf = 0;
            for(j=0;j<HID;j++){
                buf += V[j][k]*H[j];
            }
            O[k] = sigmoid(buf+out_sikii[k]);
        }
        for(k=0;k<OUT;k++){
            delta[k] = ((double)((teacher[tra]>>k)&1)-O[k])*O[k]*(1-O[k]);
        }
        
        for(j=0;j<HID;j++){
            buf = 0;
            for(k=0;k<OUT;k++){
                buf += delta[k]*V[j][k];
            }
            sigma[j] = buf*H[j]*(1-H[j]);
        }
        
        for(k=0;k<OUT;k++){
            for(j=0;j<HID;j++){
                V[j][k] = V[j][k] + alpha*delta[k]*H[j];
            }
            out_sikii[k] = out_sikii[k] + beta*delta[k];
        }
        //    printf("%f\n", sigma[0]);
        for(j=0;j<HID;j++){
            for(i=0;i<IN;i++){  
                W[i][j] = W[i][j] + alpha*sigma[j]*traning[tra][i];
            }
            hid_sikii[j] = hid_sikii[j] + beta*sigma[j];
        }  
        //    printf("%f\n", W[0][0]);
        tra = (tra + 1)%OUT;
    }
}

- (NSArray *)test:(NSArray *)bits
{
    NSMutableArray *arr = [NSMutableArray array];
    int i,j,k;
    double buf;
    for(j=0;j<HID;j++){
        buf = 0;
        for(i=0;i<IN;i++){
            buf += W[i][j]*[[bits objectAtIndex:i] intValue];
        }
        H[j] = sigmoid(buf+hid_sikii[j]);
    }
    for(k=0;k<OUT;k++){
        buf = 0;
        for(j=0;j<HID;j++){
            buf += V[j][k]*H[j];
        }
        O[k] = sigmoid(buf+out_sikii[k]);
    }
    for(k=0;k<OUT;k++){
        double per = 1.0;
        for(int dig = 0;dig<10;dig++) {
            if ((digiter[k]>>dig)&1) {
                per = per * O[dig];
            } else {
                per = per * (1-O[dig]);
            }
        }
        [arr addObject:[NSNumber numberWithDouble:per]];
        printf("%c: %.1lf%%\n", '0'+k, per*100);
    }

    return  arr;
}

@end
