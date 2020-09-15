## 1.0.28

* fix: only add parallel mode and only newest call allowance mode to single stream
  
## 1.0.27

* add parallel mode and only newest call allowance mode 
  
## 1.0.26

* remove `isLoading` in generated classes that extend `StreamState` 
  
## 1.0.25

* update type `Error` to `dynamic` in SingleStreamError and ComposedStreamsError class
  
## 1.0.24

* update StartAppError constructor: now there are 2 name constructors 
  
## 1.0.23

* update document
  
## 1.0.22

* update build system to match with built_stream 1.0.15
  
## 1.0.21

* Loose version of customized_streams dependency

## 1.0.20

* Update customized_streams dependency, switch ConvertSubject to TransformerSubject

## 1.0.19

* Update bloc writer to create class that implements `StreamBloc` instead of `Disposable` 
corresponding built_stream v1.0.13
* Degrade meta library version to ^1.1.8

## 1.0.15+16+17+18

* Update dependencies
  
## 1.0.14

* Update document
  
## 1.0.13

* Add example
  
## 1.0.12

* Now allow wrap method with no params or not return
* Trigger stream that wrap a method with no params using EmptyParams object

    Old code

    ```dart
    import 'package:built_stream/built_stream.dart';
    import 'package:customized_streams/customized_streams.dart';
    class _ReadMovies {
    @Repository('readMultiple')
    MovieRespository repository;

    @Input()
    List<int> movieIds;

    @Output()
    List<Movie> movies;
    }

    ```

    New code
    ```dart
    import 'package:built_stream/stream_annotations.dart';
    import 'package:built_stream/stream_types.dart';
    import 'package:customized_streams/customized_streams.dart';

    @SingleStream(MovieRespository, 'readMultiple')
    @StreamParam('List<int>', 'movieIds', optional: false)
    @StreamResult('List<Movie>', 'movies')
    class ReadMoviesStream extends _ReadMoviesStreamOrigin {
    @override
    String get errorMessage => 'Cannot read movies';
    }
    ```
## 1.0.11

* First release