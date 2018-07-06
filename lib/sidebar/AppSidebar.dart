import 'package:flutter/material.dart';
import 'package:clean_todo/sidebar/NewCategoryDialog.dart';
import 'package:clean_todo/beans/Category.dart';
import 'package:clean_todo/beans/CategoryGroup.dart';
import 'package:clean_todo/beans/UserData.dart';
import 'package:clean_todo/beans/CategoryData.dart';
import 'package:clean_todo/settings/SettingsManager.dart';
import 'package:clean_todo/data/DataCache.dart';
import 'package:clean_todo/lists/AboutView.dart';
import 'package:clean_todo/styles/AppIcons.dart';

class AppSidebar extends StatefulWidget {

  AppSidebar(
      { Key key, this.categories, this.addCategory, this.addCategoryGroup,
        this.filter, this.filterGroup, this.userData, this.cache, this.settings,
      })
      : super(key: key);

  final UserData userData;

  final CategoryData categories;

  final DataCache cache;
  final SettingsManager settings;

  final ValueChanged<Category> addCategory;
  final ValueChanged<CategoryGroup> addCategoryGroup;

  final ValueChanged<int> filter;
  final ValueChanged<int> filterGroup;

  @override
  _AppSidebarState createState() => new _AppSidebarState();

}

class _AppSidebarState extends State<AppSidebar> {

  var icons = new AppIcons();

  ListTile getAsSystemListTile( context, Category categoryData ){

    return new ListTile(
        dense: false,
        title: new Row (
          children: <Widget>[
            icons.systemIcon( categoryData.icon, context),
            new Padding(padding: new EdgeInsets.all( 7.0 ) ),
            new SidebarTextBold( textContent : categoryData.text ),
          ],
        ),
        onTap: () {
          this.widget.filter( categoryData.id );
        }
    );

  }

  ListTile getAsListTile( context, Category categoryData ){

    return new ListTile(
        dense: false,
        title: new Row (
          children: <Widget>[
            icons.listIcon(context),
            new Padding(padding: new EdgeInsets.all( 7.0 ) ),
            new SidebarText( textContent : categoryData.text ),
          ],
        ),
      trailing: categoryData.count == null || categoryData.count == 0 ? null :
                new Text( categoryData.count.toString(), style: new TextStyle( color: Theme.of(context).accentColor ), ),
      onTap: () {
        this.widget.filter( categoryData.id );
      }
    );

  }

  Widget getAsGroupPanel2( context, CategoryGroup categoryGroup ){
    return new Column(

        children: [
          new Divider(),
          new ListTile(
              title: new Row (
                children: <Widget>[
                  ( categoryGroup.isExpanded == null || categoryGroup.isExpanded  ) ?
                                icons.groupOpenIcon(context) : icons.groupIcon(context),
                  new Padding(padding: new EdgeInsets.all( 7.0 ) ),
                  new SidebarTextBold( textContent: categoryGroup.text ),
                ],
              ),
              trailing: new IconButton(
                icon: ( categoryGroup.isExpanded == null || categoryGroup.isExpanded  ) ?
                        icons.groupOpenArrowIcon(context) : icons.groupArrowIcon(context),

                onPressed: () {
                  this.setState(() {
                    categoryGroup.isExpanded = !categoryGroup.isExpanded;
                  });
                }
              ),

              onTap: () {
                this.widget.filterGroup( categoryGroup.id );
              }
          ),
          new Column(
            children: categoryGroup.isExpanded ?
                          this.widget.categories
                                     .getGroupMembers(categoryGroup)
                                     .map( (category){
                                        return new Padding(
                                            padding: new EdgeInsets.only( left: 20.0 ),
                                            child: getAsListTile( context, category )
                                        );
                                      }).toList()
                : [ ],
          )
        ]

    );
  }

  @override
  Widget build(BuildContext context) {

    return new Drawer(

        child: new ListView(

                padding: new EdgeInsets.only(top: 30.0),
                children: <Widget>[

                  new ListTile(
                      title: new Row(
                        children: <Widget>[
                          this.widget.userData.abbr == null ?
                          new Icon( Icons.settings, color: Theme.of(context).iconTheme.color, ) :
                          new CircleAvatar( child: new Text( this.widget.userData.abbr, style: new TextStyle( color: Colors.white ), ),
                            backgroundColor: Theme.of(context).primaryColor, ),

                          new Padding(padding: new EdgeInsets.all( 7.0 ) ),
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: this.widget.userData.email == null ?
                              <Widget>[
                                new SidebarText( textContent : this.widget.userData.userName == null ? 'Settings' : this.widget.userData.userName ) ,
                              ]
                            :
                            <Widget>[
                              new SidebarText( textContent : this.widget.userData.userName == null ? 'Settings' : this.widget.userData.userName ) ,
                              new Text( this.widget.userData.email, style: new TextStyle( color: Theme.of(context).accentColor ), ),
                            ],
                          ),
                        ],
                      ),

                      onTap: () => Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (context) => new AboutView(
                              cache: widget.cache,
                              settings: widget.settings,
                            )
                        ),
                      ),
                  ),

                  new Divider(),

                  new Column(
                    children: this.widget.categories.system.map( (category){
                      return getAsSystemListTile(context, category);
                    }).toList(),
                  ),

                  new ListTile(
                    dense: false,
                    title: new Row (
                      children: <Widget>[
                        icons.newListIcon(context),
                        new Padding(padding: new EdgeInsets.all( 7.0 ) ),
                        new SidebarTextBold( textContent : 'New List' ),
                      ],
                    ),
                    onTap: (){

                        widget.cache.categoryData.newCategoryGroup.id = -1;
                        widget.cache.categoryData.newGroup = false;

                        Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (context) =>
                                  new NewCategoryDialog(
                                    categoryData: widget.cache.categoryData,
                                    addCategory: widget.addCategory,
                                    addCategoryGroup: widget.addCategoryGroup,
                                  ),

                              maintainState: true,
                              fullscreenDialog: true,
                            )
                        );
                      },
                  ),

                  new Padding(
                      padding: new EdgeInsets.only(left:  10.0, right: 10.0),
                      child: new Column(

                        children: this.widget.categories.userGroups.map( (categoryGroup){
                          return getAsGroupPanel2(context, categoryGroup);

                        }).toList(),

                      ),
                  ),

                ],
        ),

    );
  }
}

class SidebarText extends StatelessWidget {

  SidebarText({this.textContent});

  final String textContent;

  @override
  Widget build(BuildContext context) {
    return new Text( 
      this.textContent,
      style: new TextStyle( fontSize: 16.0, fontWeight: FontWeight.w300,color: Theme.of(context).accentColor ),
    );
  }

}

class SidebarTextBold extends StatelessWidget {

  SidebarTextBold({this.textContent});

  final String textContent;

  @override
  Widget build(BuildContext context) {
    return new Text(
      this.textContent,
      style: new TextStyle( fontSize: 16.0, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor ),
    );
  }

}