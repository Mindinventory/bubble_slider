# bubble_slider

<a href="https://developer.android.com" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-android-blue">
</a>
<a href="https://developer.apple.com/ios/" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-iOS-blue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-web-blue">
</a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License"></a>

This package support a slider customize UI with bubble animation. Which is includes a onDragStart(), onDragEnd() as well as onChnage() methods callback through user get the values as per the requirements.

<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://github.com/Mindinventory/bubble_slider/blob/master/assets/bubble_slider.gif">
</a>

## Usage

### Example
    BubbleSlider(
        value: _value,
        bubbleSize: BubbleSize.medium,
        thumbRadiusSpeed: ThumbRadiusSpeed.veryFast,
        bubblesSpeed: BubbleSpeed.veryFast,
        isBubbleVisible: true,
        onChanged: (val) {
        _value = val;
        },
        onChangeEnd: (s) {},
        color: Colors.blue,
    ),

### Required parameters

##### Value:
This is for the set value of slider between 0 to 100.

##### onChanged(double val):
This is a callback. Through user can get the current value of slider.

##### onChangeEnd(double val):
This is also callback. Through user can get the current value of slider as well as user can track the slider is deactivate at the moment.

## Optional parameters

##### Color:
This is for user can set the color for slider and bubbles.

##### bubbleSize:
This is for user can set the bubbles size for slider.

##### thumbRadiusSpeed:
This is for user can set the animation speed for thumb animation for slider.

##### bubblesSpeed:
This is for user can set the animation speed for bubbles for slider.

##### isBubbleVisible:
This is for disable the bubble animation.

##### onChangeStart(double val):
This is a callback. Through user can get the drag start value of slider as well as user can track the slider is active at the moment.


## Guideline for contributors
Contribution towards our repository is always welcome, we request contributors to create a pull request to the develop branch only.

## Guideline to report an issue/feature request
It would be great for us if the reporter can share the below things to understand the root cause of the issue.
- Library version
- Code snippet
- Logs if applicable
- Device specification like (Manufacturer, OS version, etc)
- Screenshot/video with steps to reproduce the issue.

# LICENSE!
Bubble Slider is [MIT-licensed](https://github.com/Mindinventory/image_cropping/blob/master/LICENSE "MIT-licensed").

# Let us know!
We’d be really happy if you send us links to your projects where you use our component. Just send an email to sales@mindinventory.com And do let us know if you have any questions or suggestion regarding our work.