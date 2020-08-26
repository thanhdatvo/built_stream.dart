## How to use

1. Add THE latest version of [`build_runner`](https://pub.dev/packages/build_runner/install),  as a devDependence
2. Add a `build.yaml` file in the root of the project to declare the origin file to generate, for example:
    ```yaml
    targets:
    $default:
        builders:
        built_stream_generator|built_stream:
            generate_for:
            - lib/streams/built_single_stream/**.dart
            - lib/streams/built_composed_streams/**.dart
    ```

3. Run this command to generate code for [`built_stream`](https://pub.dev/packages/built_stream)
    ```sh
    flutter pub pub run build_runner build --delete-conflicting-outputs
    ```
