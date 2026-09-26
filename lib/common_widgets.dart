import 'dart:math' as math;

import 'package:flutter/material.dart';

const kContentMaxWidth = 1040.0;

/// Horizontal page padding that keeps content centred within [maxWidth].
double pageGutter(double width, [double maxWidth = kContentMaxWidth]) {
  final base = width >= 600 ? 24.0 : 16.0;
  return math.max(base, (width - maxWidth) / 2);
}

/// Scrollable page body with a centred, width-limited column.
class PageScroll extends StatelessWidget {
  const PageScroll({
    super.key,
    required this.children,
    this.maxWidth = kContentMaxWidth,
  });

  final List<Widget> children;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final gutter = pageGutter(constraints.maxWidth, maxWidth);
      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(gutter, 8, gutter, 32),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      );
    },
  );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.top = 28});

  final String title;
  final double top;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: top, bottom: 12),
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    ),
  );
}

/// Icon + text line in the muted on-surface-variant colour.
class InfoLine extends StatelessWidget {
  const InfoLine(this.icon, this.text, {super.key, this.dense = false});

  final IconData icon;
  final String text;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;
    final style = dense ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, size: dense ? 16 : 18, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: style?.copyWith(color: color))),
      ],
    );
  }
}

/// Lays children out in equal-width columns, adding columns as space allows.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 300,
    this.maxColumns = 3,
    this.spacing = 12,
    this.equalHeight = true,
  });

  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;
  final double spacing;
  final bool equalHeight;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final fit = ((constraints.maxWidth + spacing) / (minItemWidth + spacing))
          .floor();
      final columns = math.max(1, math.min(maxColumns, fit));
      final rows = <Widget>[];
      for (var start = 0; start < children.length; start += columns) {
        if (rows.isNotEmpty) rows.add(SizedBox(height: spacing));
        final row = Row(
          crossAxisAlignment: equalHeight
              ? CrossAxisAlignment.stretch
              : CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < columns; i++) ...[
              if (i > 0) SizedBox(width: spacing),
              Expanded(
                child: start + i < children.length
                    ? children[start + i]
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        );
        rows.add(equalHeight ? IntrinsicHeight(child: row) : row);
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rows,
      );
    },
  );
}
