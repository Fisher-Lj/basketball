//
//  coreData.m
//  basketball
//
//  Created by qianfeng on 15-4-20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "coreData.h"
#import "Manage.h"
@implementation coreData
{
    NSManagedObjectContext *_managedObjectContext;
    NSMutableArray *_resource;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self prepare];
        _resource=[[NSMutableArray alloc]init];
    }
    return self;
}
-(void)prepare
{
    NSString *path=[[NSBundle mainBundle]pathForResource:@"UserInfo" ofType:@"momd"];
    NSManagedObjectModel *model=[[NSManagedObjectModel alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path]];
    NSPersistentStoreCoordinator *persistentStoreCoor=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    NSString *path1=[NSHomeDirectory()stringByAppendingString:@"/Documents/UserInfo1.sqlite"];
    NSLog(@"%@",path1);
    NSError *error;
    NSPersistentStore *persistentStore=[persistentStoreCoor addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:path1] options:nil error:&error];
    if (!persistentStore) {
        NSLog(@"dddd%@",error);
        return;
    }
    _managedObjectContext=[[NSManagedObjectContext alloc]init];
    _managedObjectContext.persistentStoreCoordinator=persistentStoreCoor;
}
-(void)insert:(chatModel *)chatModel
{
    Manage *manage=[NSEntityDescription insertNewObjectForEntityForName:@"Manage" inManagedObjectContext:_managedObjectContext];
    manage.jid=chatModel.jid;
    manage.message=chatModel.message;
    manage.isSelf=chatModel.isSelf;
   // manage.date=chatModel.date;
    manage.type=chatModel.type;
    NSError *saveError;
    if (![_managedObjectContext save:&saveError]) {
        NSLog(@"fail");
    }
    [_resource addObject:manage];

}
-(NSArray *)check:(NSString *)jid withisSelf:(NSString *)isSelf;
{
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Manage"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"jid like %@ AND isSelf like %@",jid,isSelf];
    [fetchRequest setPredicate:predicate];
    NSArray *result=[_managedObjectContext executeFetchRequest:fetchRequest error:nil];
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    [_resource removeAllObjects];
    [_resource addObjectsFromArray:result];
    for (Manage *manage in result) {
        chatModel *model=[[chatModel alloc]init];
        model.message=manage.message;
        model.jid=manage.jid;
        model.isSelf=manage.isSelf;
        model.type=manage.type;
        model.date=manage.date;
        [arr addObject:model];
    }
    return arr;
    
}
-(void)update:(chatModel *)model
{

    [self check:model.jid withisSelf:model.isSelf];
    if (_resource.count!=0) {
        Manage *manage=_resource[0];
       // manage.date=model.date;
        manage.message=model.message;
        [_managedObjectContext save:nil];
    }
    else{
        [self insert:model];
    }
}
-(void)delete:(id)sender
{
    if (_resource.count>0) {
        for (Manage *manage in _resource) {
            [_managedObjectContext deleteObject:manage];
        }
    }
}
+(id)shareIntance
{
    static id s;
    if (s==nil) {
        s=[[self alloc]init];
    }

    return s;
}
-(NSArray *)check:(NSString *)myjid with:(int)page
{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Manage"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"isSelf like %@ ",myjid];//怎么根据日期取前二十个
    request.predicate=predicate;
    NSArray *result=[_managedObjectContext executeFetchRequest:request error:nil];
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:0];
    for (Manage *manage in result) {
        chatModel *model=[[chatModel alloc]init];
        model.message=manage.message;
        model.jid=manage.jid;
        model.isSelf=manage.isSelf;
        model.type=manage.type;
        model.date=manage.date;
        [arr addObject:model];
    }
    return arr;
}
@end
