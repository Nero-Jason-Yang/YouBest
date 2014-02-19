//
//  YBTypedef.h
//  YouBest
//
//  Created by Jason Yang on 14-2-19.
//  Copyright (c) 2014年 family. All rights reserved.
//

typedef enum YBItemType:uint16_t {
    YBItemType_Task,
    YBItemType_Gift,
    YBItemType_Wish,
} YBItemType;

typedef enum YBItemState:uint16_t {
    YBItemState_Finished,
    YBItemState_InProgress,
    YBItemState_Ready,
} YBItemState;
