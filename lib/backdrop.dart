import 'package:Shrine/colors.dart';
import 'package:Shrine/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'login.dart';

const double _kFlingVelocity = 2.0;

class BackDrop extends StatefulWidget {
  final Category currentCategory;
  final Widget frontLayer, backLayer, frontTitle, backTitle;

  const BackDrop(
      {this.currentCategory,
      this.frontLayer,
      this.backLayer,
      this.frontTitle,
      this.backTitle})
      : assert(currentCategory != null),
        assert(frontLayer != null),
        assert(backLayer != null),
        assert(frontTitle != null),
        assert(backTitle != null);

  @override
  _BackDropState createState() => _BackDropState();
}

// Todo: add _FrontLayer class (104)
class _FrontLayer extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  // Todo add on tap call back 104
  const _FrontLayer({
    Key key,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Material(
        elevation: 10.0,
        color: primaryColor,
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: accentColor, width: 0.5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Todo add a gesture detector 104
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              // onVerticalDragDown: (DragDownDetails details) {
              //   print(details);
              //   onTap();
              // },
              child: Container(
                height: 30.0,
                child: Center(
                  child: Material(
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    color: accentColor.withAlpha(400),
                    child: Container(
                      height: 5.0,
                      width: 70.0,
                    ),
                  ),
                ),
                alignment: AlignmentDirectional.centerStart,
              ),
            ),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

// Todo: add _backdroptitle class (104)
// Todo: add _backdropState class (104)
class _BackDropState extends State<BackDrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: "Backdrop");

  // Todo add animationController widget (104)
  AnimationController _animationController;

  @override
  void didUpdateWidget(BackDrop oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentCategory != oldWidget.currentCategory) {
      _toggleBackdropLayerVisibility();
    } else if (!_frontLayerVisible) {
      _toggleBackdropLayerVisibility();
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(microseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _frontLayerVisible {
    final AnimationStatus status = _animationController.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _animationController.fling(
        velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
  }

  // Todo add buildContext and BoxConstraints parameters to _buildStack()
  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    // todo create a relative rect tween animation 104
    const double layerTitleHeight = 48.0;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    // TODO: Create a RelativeRectTween Animation (104)
    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, layerTop, 0.0, layerTop - layerSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_animationController.view);

    return Stack(
      key: _backdropKey,
      children: <Widget>[
        // Todo wrap backLayer in an excludeSemantics widget (104)
        ExcludeSemantics(
          child: widget.backLayer,
          excluding: _frontLayerVisible,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(
            onTap: _toggleBackdropLayerVisibility,
            child: widget.frontLayer,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: Add app bar (102)
      appBar: AppBar(
        // todo: add conditional statement to turn elevation on
        elevation: 0.0,
        brightness: Brightness.light,
        titleSpacing: 0.0,
        // Todo replace leading menu with iconButton (104)
        // Todo remove leading property (104)
        // Todo create title with _BackdropTitle parameter (104)
        title: _BackdropTitle(
          listenable: _animationController.view,
          onPress: _toggleBackdropLayerVisibility,
          frontTitle: widget.frontTitle,
          backTitle: widget.backTitle,
        ),
        centerTitle: true,
        // TODO: add trailing buttons (102)
        actions: <Widget>[
          // Todo add shortcut to login screen from trailing icons (104)
          IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: "search",
            ),
            onPressed: () {
              print("my search button");
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => LoginPage(),
                    fullscreenDialog: true,
                  ));
            },
          ),
          IconButton(
            onPressed: () {
              print("filter button");
            },
            icon: Icon(
              Icons.tune,
              semanticLabel: "filter",
            ),
          ),
        ],
      ),
      // Todo return a layoutBuild widget (104)
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }
}

// TODO: Add _BackdropTitle class (104)
class _BackdropTitle extends AnimatedWidget {
  final Function onPress;
  final Widget frontTitle;
  final Widget backTitle;

  const _BackdropTitle({
    Key key,
    Listenable listenable,
    this.onPress,
    @required this.frontTitle,
    @required this.backTitle,
  })  : assert(frontTitle != null),
        assert(backTitle != null),
        super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.listenable;

    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.title,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Row(children: <Widget>[
        // branded icon
        SizedBox(
          width: 72.0,
          child: IconButton(
            padding: EdgeInsets.only(right: 8.0),
            onPressed: this.onPress,
            icon: Stack(children: <Widget>[
              Opacity(
                opacity: animation.value,
                child: ImageIcon(AssetImage('assets/slanted_menu.png')),
              ),
              FractionalTranslation(
                translation: Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset(1.0, 0.0),
                ).evaluate(animation),
                child: ImageIcon(AssetImage('assets/diamond.png')),
              )
            ]),
          ),
        ),
        // Here, we do a custom cross fade between backTitle and frontTitle.
        // This makes a smooth animation between the two texts.
        Stack(
          children: <Widget>[
            Opacity(
              opacity: CurvedAnimation(
                parent: ReverseAnimation(animation),
                curve: Interval(0.5, 1.0),
              ).value,
              child: FractionalTranslation(
                translation: Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset(0.5, 0.0),
                ).evaluate(animation),
                child: backTitle,
              ),
            ),
            Opacity(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Interval(0.5, 1.0),
              ).value,
              child: FractionalTranslation(
                translation: Tween<Offset>(
                  begin: Offset(-0.25, 0.0),
                  end: Offset.zero,
                ).evaluate(animation),
                child: frontTitle,
              ),
            ),
          ],
        )
      ]),
    );
  }
}
