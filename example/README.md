# bubble_slider


<a href="https://pub.dev/packages/image_cropping"><img src="https://img.shields.io/pub/v/image_cropping.svg?label=image_cropping" alt="image_cropping version"></a>
<a href="https://github.com/Mindinventory/image_cropping"><img src="https://img.shields.io/github/stars/Mindinventory/image_cropping?style=social" alt="MIT License"></a>
<a href="https://developer.android.com" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-android-blue">
</a>
<a href="https://developer.apple.com/ios/" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-iOS-blue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-web-blue">
</a>

This package containes a bubble animation slider widget.

## Usage

### Example
BubbleSlider(
    value: _value,
    isBubbleVisible: true,
    onChanged: (val) {
    _value = val;
    },
    onChangeEnd: (s) {},
    color: Colors.blue,
    ),
),

### Required parameters

##### Value:
This is use for gives slider value between o to 100.

##### onChanged:
This is use for callback of value which is user drag slider.