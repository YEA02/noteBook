//
//  ViewController.h
//  noteBook
//
//  Created by csdc-iMac on 2018/9/13.
//  Copyright © 2018年 K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNoteViewController.h"
#import "NoteCollectionViewCell.h"
#import "DetailViewController.h"

@interface ViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AddProtocol,SaveProtocol,UISearchResultsUpdating,UISearchControllerDelegate,NoteCollectionViewCellDelegate>


@end

