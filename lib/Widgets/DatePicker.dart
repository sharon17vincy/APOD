import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'PickerHeader.dart';




const Size _calendarPortraitDialogSize = Size(330.0, 518.0);
const Size _calendarLandscapeDialogSize = Size(496.0, 346.0);
const Size _inputPortraitDialogSize = Size(330.0, 270.0);
const Size _inputLandscapeDialogSize = Size(496, 160.0);
const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);
const double _inputFormPortraitHeight = 98.0;
const double _inputFormLandscapeHeight = 108.0;

Future<DateTime> DatePicker({
  @required BuildContext context,
  @required DateTime initialDate,
  @required DateTime firstDate,
  @required DateTime lastDate,
  DateTime currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  SelectableDayPredicate selectableDayPredicate,
  String helpText,
  String cancelText,
  String confirmText,
  Locale locale,
  bool useRootNavigator = true,
  RouteSettings routeSettings,
  TextDirection textDirection,
  TransitionBuilder builder,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  String errorFormatText,
  String errorInvalidText,
  String fieldHintText,
  String fieldLabelText,
}) async {
  assert(context != null);
  assert(initialDate != null);
  assert(firstDate != null);
  assert(lastDate != null);
  initialDate = DateTime(initialDate.year, initialDate.month, initialDate.day,0,0,0,0,0);
  firstDate = DateTime(firstDate.year, firstDate.month, firstDate.day,0,0,0,0,0);
  lastDate = DateTime(lastDate.year, lastDate.month, lastDate.day,0,0,0,0,0);
  assert(
  !lastDate.isBefore(firstDate),
  'lastDate $lastDate must be on or after firstDate $firstDate.'
  );
  assert(
  !initialDate.isBefore(firstDate),
  'initialDate $initialDate must be on or after firstDate $firstDate.'
  );
  assert(
  !initialDate.isAfter(lastDate),
  'initialDate $initialDate must be on or before lastDate $lastDate.'
  );
  assert(
  selectableDayPredicate == null || selectableDayPredicate(initialDate),
  'Provided initialDate $initialDate must satisfy provided selectableDayPredicate.'
  );
  assert(initialEntryMode != null);
  assert(useRootNavigator != null);
  assert(initialDatePickerMode != null);
  assert(debugCheckHasMaterialLocalizations(context));

  Widget dialog = _DatePickerDialog(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    initialEntryMode: initialEntryMode,
    selectableDayPredicate: selectableDayPredicate,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    initialCalendarMode: initialDatePickerMode,
    errorFormatText: errorFormatText,
    errorInvalidText: errorInvalidText,
    fieldHintText: fieldHintText,
    fieldLabelText: fieldLabelText,
  );

  if (textDirection != null)
  {
    dialog = Directionality(
      textDirection: textDirection,
      child: dialog,
    );
  }

  if (locale != null)
  {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }

  return showDialog<DateTime>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}

class _DatePickerDialog extends StatefulWidget {
  _DatePickerDialog({
    Key key,
    @required DateTime initialDate,
    @required DateTime firstDate,
    @required DateTime lastDate,
    DateTime currentDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.selectableDayPredicate,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.initialCalendarMode = DatePickerMode.day,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
  }) : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        initialDate = DateTime(initialDate.year, initialDate.month, initialDate.day,0,0,0,0,0),
        firstDate = DateTime(firstDate.year, firstDate.month, firstDate.day,0,0,0,0,0),
        lastDate = DateTime(lastDate.year, lastDate.month, lastDate.day,0,0,0,0,0),
        currentDate = currentDate,
        assert(initialEntryMode != null),
        assert(initialCalendarMode != null),
        super(key: key) {
    assert(
    !this.lastDate.isBefore(this.firstDate),
    'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.'
    );
    assert(
    !this.initialDate.isBefore(this.firstDate),
    'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.'
    );
    assert(
    !this.initialDate.isAfter(this.lastDate),
    'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.'
    );
    assert(
    selectableDayPredicate == null || selectableDayPredicate(this.initialDate),
    'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate'
    );
  }

  /// The initially selected [DateTime] that the picker should display.
  final DateTime initialDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  final DatePickerEntryMode initialEntryMode;

  /// Function to provide full control over which [DateTime] can be selected.
  final SelectableDayPredicate selectableDayPredicate;

  /// The text that is displayed on the cancel button.
  final String cancelText;

  /// The text that is displayed on the confirm button.
  final String confirmText;

  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String helpText;

  /// The initial display of the calendar picker.
  final DatePickerMode initialCalendarMode;

  final String errorFormatText;

  final String errorInvalidText;

  final String fieldHintText;

  final String fieldLabelText;

  @override
  _DatePickerDialogState createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<_DatePickerDialog> {

  DatePickerEntryMode _entryMode;
  DateTime _selectedDate;
  bool _autoValidate;
  final GlobalKey _calendarPickerKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _entryMode = widget.initialEntryMode;
    _selectedDate = widget.initialDate;
    _autoValidate = false;
  }

  void _handleOk() {
    if (_entryMode == DatePickerEntryMode.input) {
      final FormState form = _formKey.currentState;
      if (!form.validate()) {
        setState(() => _autoValidate = true);
        return;
      }
      form.save();
    }
    Navigator.pop(context, _selectedDate);
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleEntryModeToggle() {
    setState(() {
      switch (_entryMode) {
        case DatePickerEntryMode.calendar:
          _autoValidate = false;
          _entryMode = DatePickerEntryMode.input;
          break;
        case DatePickerEntryMode.input:
          _formKey.currentState.save();
          _entryMode = DatePickerEntryMode.calendar;
          break;
      }
    });
  }

  void _handleDateChanged(DateTime date) {
    setState(() => _selectedDate = date);
  }

  Size _dialogSize(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    switch (_entryMode) {
      case DatePickerEntryMode.calendar:
        switch (orientation) {
          case Orientation.portrait:
            return _calendarPortraitDialogSize;
          case Orientation.landscape:
            return _calendarLandscapeDialogSize;
        }
        break;
      case DatePickerEntryMode.input:
        switch (orientation) {
          case Orientation.portrait:
            return _inputPortraitDialogSize;
          case Orientation.landscape:
            return _inputLandscapeDialogSize;
        }
        break;
    }
    return null;
  }

  static final Map<LogicalKeySet, Intent> _formShortcutMap = <LogicalKeySet, Intent>{
    // Pressing enter on the field will move focus to the next field or control.
    LogicalKeySet(LogicalKeyboardKey.enter): const NextFocusIntent(),
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final Orientation orientation = MediaQuery.of(context).orientation;
    final TextTheme textTheme = theme.textTheme;
    // Constrain the textScaleFactor to the largest supported value to prevent
    // layout issues.
    final double textScaleFactor = math.min(MediaQuery.of(context).textScaleFactor, 1.3);

    final String dateText = _selectedDate != null
        ? localizations.formatMediumDate(_selectedDate)
        : localizations.unspecifiedDate;
    final Color dateColor = colorScheme.brightness == Brightness.light
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final TextStyle dateStyle = orientation == Orientation.landscape
        ? textTheme.headline5?.copyWith(color: dateColor)
        : textTheme.headline4?.copyWith(color: dateColor);

    final Widget actions = Container(
      alignment: AlignmentDirectional.centerEnd,
      constraints: const BoxConstraints(minHeight: 52.0),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: OverflowBar(
        spacing: 8,
        children: <Widget>[
          TextButton(
            child: Text(widget.cancelText ?? localizations.cancelButtonLabel),
            onPressed: _handleCancel,
          ),
          TextButton(
            child: Text(widget.confirmText ?? localizations.okButtonLabel),
            onPressed: _handleOk,
          ),
        ],
      ),
    );

    Widget picker;
    IconData entryModeIcon;
    String entryModeTooltip;
    switch (_entryMode)
    {
      case DatePickerEntryMode.calendar:
        picker = CalendarDatePicker(
          key: _calendarPickerKey,
          initialDate: _selectedDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          currentDate: widget.currentDate,
          onDateChanged: _handleDateChanged,
          selectableDayPredicate: widget.selectableDayPredicate,
          initialCalendarMode: widget.initialCalendarMode,
        );
        entryModeIcon = Icons.edit;
        entryModeTooltip = localizations.inputDateModeButtonLabel;
        break;

      case DatePickerEntryMode.input:
        picker = Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            height: orientation == Orientation.portrait ? _inputFormPortraitHeight : _inputFormLandscapeHeight,
            child: Shortcuts(
              shortcuts: _formShortcutMap,
              child: Column(
                children: <Widget>[
                  const Spacer(),
                  InputDatePickerFormField(
                    initialDate: _selectedDate,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                    onDateSubmitted: _handleDateChanged,
                    onDateSaved: _handleDateChanged,
                    selectableDayPredicate: widget.selectableDayPredicate,
                    errorFormatText: widget.errorFormatText,
                    errorInvalidText: widget.errorInvalidText,
                    fieldHintText: widget.fieldHintText,
                    fieldLabelText: widget.fieldLabelText,
                    autofocus: true,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
        entryModeIcon = Icons.calendar_today;
        entryModeTooltip = localizations.calendarModeButtonLabel;
        break;
    }

    final Widget header = PickerHeader(
      helpText: widget.helpText ?? localizations.datePickerHelpText,
      titleText: dateText,
      titleStyle: dateStyle,
      orientation: orientation,
      isShort: orientation == Orientation.landscape,
      icon: entryModeIcon,
      iconTooltip: entryModeTooltip,
      onIconPressed: _handleEntryModeToggle,
    );

    final Size dialogSize = _dialogSize(context) * textScaleFactor;
    return Dialog(
      child: AnimatedContainer(
        width: dialogSize.width,
        height: dialogSize.height,
        duration: _dialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: textScaleFactor,
          ),
          child: Builder(builder: (BuildContext context) {
            switch (orientation) {
              case Orientation.portrait:
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    header,
                    Expanded(child: picker),
                    actions,
                  ],
                );
              case Orientation.landscape:
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    header,
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(child: picker),
                          actions,
                        ],
                      ),
                    ),
                  ],
                );
            }
            return null;
          }),
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      clipBehavior: Clip.antiAlias,
    );
  }
}
