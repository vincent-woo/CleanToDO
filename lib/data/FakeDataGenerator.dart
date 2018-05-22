import 'package:flutter/material.dart';
import 'package:clean_todo/beans/CategoryData.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/beans/UserData.dart';
import 'package:clean_todo/beans/Task.dart';
import 'package:clean_todo/data/DataProvider.dart';
import 'package:clean_todo/calender/DateUtil.dart';
import 'package:clean_todo/calender/DateToString.dart';

class FakeDataGenerator implements DataProvider {

  CategoryData getSidebarData(){

    return new CategoryData(

      system: [
          new Category( id: -1, text: 'My Day', icon: Icons.lightbulb_outline ),
          new Category( id: -2, text: 'To-Do', icon: Icons.check ),
      ],

      user: [
        new Category( text: 'Home', count: 3 ),
        new Category( text: 'Work', count: 2 ),
        new Category( text: 'Shopping', count: 2 ),
      ],

    );

  }

  UserData getUserData(){
    return new UserData( 'Sandra Smith' );
  }

  List<Task> getAllTasks(){

    String yesterday = '20180505';
    String today = DateUtil.parse( DateToString.today );
    String tomorrow = DateUtil.parse( DateToString.tomorrow );
    String next_week = DateUtil.parse( DateToString.next_week );

    return [
      new Task( id : 0, completed : false, title: 'fix the lightbulb', category: new Category( text: 'Home' ) , deadline_val: yesterday, reminder_date: '20190519', reminder_time: '0900', notes:  'yes' ),
      new Task( id : 1, completed : false, title: 'clean the garden', category: new Category( text: 'Home' ) ),
      new Task( id : 2, completed : false, title: 'fix the fire hose', category: new Category( text: 'Home' ), deadline_val: next_week, reminder_date: '20190520', reminder_time: '0900', ),
      new Task( id : 3, completed : true, title: 'finish the annual reports', category: new Category( text: 'Work' ) ),
      new Task( id : 4, completed : false, title: 'come up with ideas for the pre-sales task', category: new Category( text: 'Work' ), deadline_val: next_week ),
      new Task( id : 5, completed : false, title: 'buy ring for aniversary', category: new Category( text: 'Shopping' ) ),
      new Task( id : 6, completed : false, title: 'buy shirts for presentation', category: new Category( text: 'Shopping' ), reminder_date: '20190522', reminder_time: '0900', ),
    ];
  }

}