//
//  ViewController.m
//  NNotes
//
//  Created by Ольга Выростко on 12.06.16.
//  Copyright © 2016 Ольга Выростко. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *noteTitle;
@property (weak, nonatomic) IBOutlet UITextView * text;
@property (weak, nonatomic) IBOutlet UILabel *colorMark;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // В том случае, если установлен индекс,
    // редактируем уже существующую заметку -> нужно загрузить данные
    if ( -1 != self.index ) {
        Note * note = [self.dataCtrl selectNoteByIndex: self.index];
        self.noteTitle.text = note.title;
        self.text.text = note.text;
        
        UIColor * clr = [[UIColor alloc] initWithRed: [note.colorR doubleValue] green: [note.colorG doubleValue] blue: [note.colorB doubleValue] alpha: [[[NSNumber alloc] initWithDouble: 1] doubleValue]];
        self.colorMark.backgroundColor = clr;
        self.noteTitle.backgroundColor = clr;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)addOrEditNote:(id)sender {
    #if (CGFLOAT_IS_DOUBLE == 1)
        double clrR, clrG, clrB, alpha;
    #else
        float clrR, clrG, clrB, alpha;
    #endif
    
    UIColor * clr = self.noteTitle.backgroundColor;
    [ clr getRed: &clrR green: &clrG blue: &clrB alpha: &alpha];
    
    Note * note = [[Note alloc] initWithTitle: self.noteTitle.text Text: self.text.text ColorR: [[NSNumber alloc] initWithDouble: clrR ] ColorG: [[NSNumber alloc] initWithDouble: clrG ] andColorB: [[NSNumber alloc] initWithDouble: clrB ] ];
    
    // Если на экране добавления заметки, вызываем метод создания новой заметки;
    // Если на экране редактирования заметки, вызываем метод обновления существующих данных
    if ( -1 == self.index )
        [self.dataCtrl addNote: note];
    else
        [self.dataCtrl updateNoteAtIndex: self.index WithNote: note];
    
    // И возвращаемся на экран со списком заметок
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController * tableViewController = (ViewController *)[storyboard  instantiateViewControllerWithIdentifier:@"NotesTableViewController"];
    
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (IBAction)removeNote:(id)sender {
    // Удаление нужно осуществлять, только если вызвано оно с экрана редактирования:
    // в противном случае заметки и так пока нет, ничего делать не надо
    if ( -1 != self.index ) {
        [ self.dataCtrl removeNoteByIndex: self.index ];
    }
    
    // Возвращаемся на экран со списком заметок
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController * tableViewController = (ViewController *)[storyboard  instantiateViewControllerWithIdentifier:@"NotesTableViewController"];
    
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (IBAction)changeColor:(id)sender {
    // Устанавливаем новый цвет заметки
    UIButton * button = (UIButton *) sender;
    self.noteTitle.backgroundColor = button.backgroundColor;
    self.colorMark.backgroundColor = button.backgroundColor;
}

@end
