# MOMO(모모) - 미혼모를 위한 감정일기 및 정보제공 서비스

![momo](https://user-images.githubusercontent.com/69891604/187994128-c1262fa5-c323-4132-a0ea-ed8e9e1f6656.png)


'MOMO(모모)'앱은 미혼모들이 사회에 정착할 수 있도록 도와주는 정보전달 및 감정일기 앱입니다. 미혼모들이 자신의 감정을 음성 및 글로 정리를 할 수 있으며, 엄마가 되기 위한 준비를 하지 못한 청소년 미혼모, 초기 미혼모를 대상으로 베이비박스에 아이를 버리지 않고, 엄마 품에서 지낼 수 있도록 로드맵 및 정보를 제공합니다.이 앱은 현대오토에버와 서울 사회복지공동모금회의 지원으로 제작되었습니다.


**앱스토어에서 현재는 내려간 상태입니다**

## 기획의도
많은 미혼모들이 산후우울증, 산전우울증에 많이 걸리고 있습니다. 이러한 우울증은 미혼모들이 아이를 출산했을 때로부터 오는 경제적, 심리적 압박감이 많이 작용한다고 합니다. 이러한 미혼모들에게 심리적 압박감과 경제적인 압박감으로 부터 조금이라도 안정감을 주고자 앱을 기획했습니다. 기획하는 도중, 한국 미혼모 협회, 한국 미혼모 지원 네트워크와의 미팅 및 전국 미혼모 센터와의 메일 및 유선 소통을 하면서, 사용자 중심으로 앱을 기획했습니다. 
* 모모 기획서

## Dependencies
```
'SwiftGen', '~> 6.0'
'Firebase', '~> 8.0'
'Kingfisher', '~> 7.0'
'SnapKit', '~> 5.0.1'
'Realm', '~> 10.20.2'
'swift-collections', '~> 1.0.0'
'Toast', '~> 5.0.0'
'RxSwift', '~> 6.0.0'
'Then', '~> 2.0.0'
'RxGesture', '~> 4.0.3'
'Lottie', '~> 3.2.1'
```

## Rx + Clean Architecture
* 기존의 앱은 MVC 기반으로 개발되었다. MVC를 선택한 이유는 앱을 기획하고, 개발하는데 있어서 해커톤 일정을 맞추기 위한 속도가 중시되었다. 또한 직관적인 UI 개발을 위하여 storyboard를 활용한 개발이 진행되었다.
* 운영을 하면서, RxSwift를 기반으로 한 Clean Architecture을 도입중에 있다. 현재는 로그인, 회원가입을 제외한 대부분의 기능이 모두 RX + Clean Architecture로 변화가 이루어졌다.
* [모모의 Rx + Clean Architecture 도입기](https://github.com/Moms-Touch/MOMO/wiki)

## Moya와 비슷한 API Manager 만들기
* Moya 라이브러리를 쓰지 않으면서, Moya 처럼 Network layer를 쌓는 방식을 채택했다. 서버 개발자들과 협업을 하면서, REST API를 활용할 때, JSON Encoding, URL Encoding 형식만을 사용하고, Response 형식도 맞췄기 때문에, 제너릭한 코드를 작성할 수 있었다.
* [모모의 API Manager 만들기](https://github.com/Moms-Touch/MOMO/wiki)

## FSCalendar 걷어내기
* 기존의 앱은 빠른 달력 개발을 위해서 FSCalendar를 사용했다. 하지만 FSCalendar를 커스텀하는 것보다, 달력기능을 직접만들어서 보여주는 것이 편했기 때문에, 운영하는 도중, 달력을 만들고 FSCalendar를 걷어냈다.
* [모모의 FSCaldendar 걷어내기](https://github.com/Moms-Touch/MOMO/wiki/FSCalendar-%EA%B1%B7%EC%96%B4%EB%82%B4%EA%B8%B0)
<p class='center'> 
    <img src="https://user-images.githubusercontent.com/69891604/187993667-10f09c7f-18f2-47ee-a8ef-b8f6e781c561.png" width="200" height="400"/>
</p>

## KingFisher 걷어내기
* KingFisher의 기능은 많지만, MOMO에서 사용하는 기능은 이미지 캐싱하는 기능만 사용한다. 그렇기 때문에 이미지 캐싱 class와 protocol을 사용해서 KingFisher을 걷어냈다.
* [모모의 KingFisher 걷어내기](https://github.com/Moms-Touch/MOMO/wiki)

## URLSessionProtocol 
* 모모에서는 URLSession을 사용할 때, 테스트가 용이한 코드를 작성하기 위해서 URLSession과 URLSessionTask를 mocking할 수 있는 장치를 마련한다. 그를 위해서 URLSession과 URLSessionTask에 채택시킬 각각의 protocol을 만들고, 그 프로토콜을 채택한 mock 객체를 만들 수 있다.
* [모모의 URLSession Testable하게 만들기](https://github.com/Moms-Touch/MOMO/wiki)

## License
```
MIT License

Copyright (c) 2022 Moms-Touch

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
