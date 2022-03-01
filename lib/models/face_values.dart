import 'package:flutter/rendering.dart';

///Display values for Sides on each cube (1-15).
List<List<int>> faceValues = [
// A  B  C  D  E  F
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
  [1, 2, 1, 2, 3, 3],
];

Color blue = Color(0xFF0468D7);
Color darkBlue = Color(0xFF043875);
Color lightBlue = Color(0xFF13B9FD);

List<List<Color>> faceColors = [
// A  B  C  D  E  F
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
  [blue, darkBlue, blue, darkBlue, lightBlue, lightBlue],
];




  // [0, 0, 0, 0, 0, 0],
  // [1, 8, 12, 6, 7, 5],//
  // [2, 1, 8, 10, 7, 5],//
  // [3, 2, 1, 6, 5, 7],//
  // [4, 3, 2, 12, 5, 7],//
  // [5, 7, 7, 6, 2, 4],//
  // [6, 11, 8, 7, 12, 10],//
  // [7, 7, 1, 8, 4, 2],//
  // [8, 11, 13, 9, 10, 12],//
  // [9, 5, 10, 14, 15, 13],
  // [10, 9, 8, 4, 5, 7],//
  // [11, 10, 9, 14, 13, 15],//
  // [12, 11, 10, 4, 7, 5],//
  // [13, 5, 15, 14, 10, 12],//
  // [14, 11, 7, 15, 10, 12],//
  // [15, 5, 9, 7, 12, 10],//

  // [0, 0, 0, 0, 0, 0],
  // [10, 11, 12, 13, 14, 15],
  // [20, 21, 22, 23, 24, 25],
  // [30, 31, 32, 33, 34, 35],
  // [40, 41, 42, 43, 44, 45],
  // [50, 51, 52, 53, 54, 55],
  // [60, 61, 62, 63, 64, 65],
  // [70, 71, 72, 73, 74, 75],
  // [80, 81, 82, 83, 84, 85],
  // [90, 91, 92, 93, 94, 95],
  // [100, 101, 102, 103, 104, 105],
  // [110, 111, 112, 113, 114, 115],
  // [120, 121, 122, 123, 124, 125],
  // [130, 131, 132, 133, 134, 135],
  // [140, 141, 142, 143, 144, 145],
  // [150, 151, 152, 153, 154, 155],

// [9, 91, 92, 93, 94, 13],
// [10, 9, 102, 103, 104, 105],
// [11, 10, 112, 113, 114, 115],
// [12, 11, 122, 123, 124, 125],
// [13, 131, 132, 14, 134, 135],
// [15, 151, 152, 15, 154, 155],
// [14, 141, 142, 143, 12, 145],

// [9, 91, 92, 93, 94, 95],
// [10, 101, 102, 103, 104, 105],
// [11, 111, 112, 113, 114, 115],
// [12, 121, 122, 123, 124, 125],
// [13, 131, 132, 133, 134, 135],
// [15, 151, 152, 153, 154, 155],
// [14, 141, 142, 143, 144, 145],

// [90, 91, 92, 93, 94, 95],
// [100, 101, 102, 103, 104, 105],
// [110, 111, 112, 113, 114, 115],
// [120, 121, 122, 123, 124, 125],
// [130, 131, 132, 133, 134, 135],
// [140, 141, 142, 143, 144, 145],
// [150, 151, 152, 153, 154, 155],

// List<List<int>> faceValues = [
// // A  B  C  D  E  F
//   [0, 0, 0, 0, 0, 0],
//   [1, 2, 3, 4, 5, 6],
//   [2, 3, 4, 5, 6, 7],
//   [3, 4, 5, 6, 7, 8],
//   [4, 5, 6, 7, 8, 9],
//   [5, 6, 7, 8, 9, 10],
//   [6, 7, 8, 9, 10, 11],
//   [7, 8, 9, 10, 11, 12],
//   [8, 9, 10, 11, 12, 13],
//   [9, 12, 11, 10, 9, 11],
//   [10, 12, 13, 9, 10, 8],
//   [11, 15, 14, 13, 15, 10],
//   [12, 13, 14, 11, 10, 9],
//   [13, 13, 10, 10, 15, 10],
//   [15, 14, 13, 9, 10, 11],
//   [14, 15, 13, 13, 11, 10],
// ];

///
List<List<int>> correctFaceValues = [
  [1, 1, 1, 1],
  [1, 1, 1, 1],
  [3, 3, 3, 3],
  [3, 3, 3, 3],
];
