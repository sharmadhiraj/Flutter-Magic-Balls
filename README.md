# Flutter Magic Balls

Bouncing balls inside a circular arena. A ball that hits the wall duplicates itself, and two balls
that touch each other both vanish. Built with Flutter only, no external packages.

**[Try the web demo](https://sharmadhiraj.github.io/Flutter-Magic-Balls/)**

## Features

- Frame-rate independent movement driven by a single `Ticker`
- Every wall hit duplicates the ball in a different random color, up to a maximum count
- When two balls touch, both vanish (a new ball starts from the center if none are left)
- Pause and reset controls
- Haptic feedback on wall hits
- The arena border glows in the color of the ball that hit it

## Getting Started

```sh
git clone https://github.com/sharmadhiraj/Flutter-Magic-Balls
cd Flutter-Magic-Balls
flutter pub get
flutter run
```

Run the checks:

```sh
flutter analyze
flutter test
```

## Configuration

Everything tunable lives in [`lib/config.dart`](lib/config.dart): ball radius and speed, maximum
ball count, border width, glow duration, and the color palette.

## Project Structure

```
lib/
  main.dart                  App entry point
  config.dart                Tunable constants
  models/ball.dart           Ball
  arena/
    arena.dart               Simulation: movement, wall bounces, duplication, collisions
    offset_math.dart         Small vector helpers (dot, reflect)
  screens/home.dart          Ticker loop and pause/reset buttons
  widgets/arena_painter.dart Draws the arena border and balls
test/                        Unit and widget tests
```

The simulation (`Arena`) has no widget dependencies, so it is easy to test. The screen advances it
on every frame, and `ArenaPainter` repaints from it without rebuilding any widgets.

## Roadmap

- Settings for speed, ball size and maximum count
- Sound effects

## Contributing

Issues and pull requests are welcome. Please run `flutter analyze` and `flutter test` before opening
a PR.

## License

[MIT](LICENSE)
