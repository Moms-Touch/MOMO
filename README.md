# 모모 - 미혼모를 위한 감정일기 및 정보제공 서비스

- 모모는 미혼모들이 사회에 정착할 수 있도록 도와주는 정보전달 및 감정일기 앱입니다.
- 저희는 [현대오토에버 배리어프리 앱 컨테스트](https://www.autoeverapp.kr)에서 최종 제작 지원 10팀으로 선정되어 400만원을 지원받았습니다.
- 이 앱은 현대오토에버와 서울 사회복지공동모금회의 지원으로 제작되었습니다.

<img src="https://user-images.githubusercontent.com/69891604/187994128-c1262fa5-c323-4132-a0ea-ed8e9e1f6656.png" width=80%>

**앱스토어에서 현재는 내려간 상태입니다**

## 기획의도
- 대한민국의 미혼모들이 아이를 출산하고 양육하면서 겪는 경제적, 심리적 압박감을 해소하는데 도움을 주는 앱을 만들고 싶었습니다.
- 기획하는 도중, 한국 미혼모 협회, 한국 미혼모 지원 네트워크와의 미팅 및 전국 미혼모 센터와의 메일 및 유선 소통을 하면서, 사용자 중심으로 앱을 기획했습니다. 

## 핵심 기능
- 미혼모를 포함한 임산부들을 위한 출산육아 로드맵 및 팁을 제공합니다.
- 자신의 감정을 음성 및 글로 정리를 할 수 있습니다.
- 미혼모 지원 정책 검색 기능을 제공합니다.

## 프로젝트 구조
- 작성 예정

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

## 개선점

### Rx + Clean Architecture
* 기존의 앱은 MVC 기반으로 개발되었다. MVC를 선택한 이유는 앱을 기획하고, 개발하는데 있어서 해커톤 일정을 맞추기 위한 속도가 중시되었다. 또한 직관적인 UI 개발을 위하여 storyboard를 활용한 개발이 진행되었다.
* 운영을 하면서, RxSwift를 기반으로 한 Clean Architecture을 도입중에 있다. 현재는 로그인, 회원가입을 제외한 대부분의 기능이 모두 RX + Clean Architecture로 변화가 이루어졌다.
* [모모의 Rx + Clean Architecture 도입기](https://github.com/Moms-Touch/MOMO/wiki)

### Moya와 비슷한 API Manager 만들기
* Moya 라이브러리를 쓰지 않으면서, Moya 처럼 Network layer를 쌓는 방식을 채택했다. 서버 개발자들과 협업을 하면서, REST API를 활용할 때, JSON Encoding, URL Encoding 형식만을 사용하고, Response 형식도 맞췄기 때문에, 제너릭한 코드를 작성할 수 있었다.
* [모모의 API Manager 만들기](https://github.com/Moms-Touch/MOMO/wiki/Moya%EC%99%80-%EB%B9%84%EC%8A%B7%ED%95%9C-API-Manager-%EB%A7%8C%EB%93%A4%EA%B8%B0)

### FSCalendar 걷어내기
* 기존의 앱은 빠른 달력 개발을 위해서 FSCalendar를 사용했다. 하지만 FSCalendar를 커스텀하는 것보다, 달력기능을 직접만들어서 보여주는 것이 편했기 때문에, 운영하는 도중, 달력을 만들고 FSCalendar를 걷어냈다.
* [모모의 FSCaldendar 걷어내기](https://github.com/Moms-Touch/MOMO/wiki/FSCalendar-%EA%B1%B7%EC%96%B4%EB%82%B4%EA%B8%B0)
<p class='center'> 
    <img src="https://user-images.githubusercontent.com/69891604/187993667-10f09c7f-18f2-47ee-a8ef-b8f6e781c561.png" width="200" height="400"/>
</p>

### KingFisher 걷어내기
* KingFisher의 기능은 많지만, MOMO에서 사용하는 기능은 이미지 캐싱하는 기능만 사용한다. 그렇기 때문에 이미지 캐싱 class와 protocol을 사용해서 KingFisher을 걷어냈다.
* [모모의 KingFisher 걷어내기](https://github.com/Moms-Touch/MOMO/wiki)

### URLSessionProtocol 
* 모모에서는 URLSession을 사용할 때, 테스트가 용이한 코드를 작성하기 위해서 URLSession과 URLSessionTask를 mocking할 수 있는 장치를 마련한다. 그를 위해서 URLSession과 URLSessionTask에 채택시킬 각각의 protocol을 만들고, 그 프로토콜을 채택한 mock 객체를 만들 수 있다.
* [모모의 URLSession Testable하게 만들기](https://github.com/Moms-Touch/MOMO/wiki/%EB%AA%A8%EB%AA%A8%EC%9D%98-URLSession-Testable%ED%95%98%EA%B2%8C-%EB%A7%8C%EB%93%A4%EA%B8%B0)

### CollectionView의 크기가 마음대로 정해지는 issue
* collectionView cell의 크기가 image로 인해 마음대로 정해지는 issue가 발생했다. 이로 인해서 cell의 크기를 미리 정해줘야하는 issue가 생겼다. 
* [collectionView cell의 최적화 크기 찾기](https://github.com/Moms-Touch/MOMO/wiki/collectionView-cell%EC%9D%98-%EC%B5%9C%EC%A0%81%ED%99%94-%ED%81%AC%EA%B8%B0-%EC%B0%BE%EA%B8%B0)

### TextView에 글을 쓸 때, keyboard 영역 아래로 내려가는 issue
* textview에 글을 쓰다보면, keyboard 영역 아래로 계속 내려가는 issue가 발생했다. 커서를 기준으로 자동스크롤이 진행되어야하는데, 그렇지 않았다. 그렇기에, textview를 키보드의 유무에 따라서 autoLayout 변경했다.
* [TextView에 글을 쓸 때, keyboard 영역 아래로 내려가는 issue](https://github.com/Moms-Touch/MOMO/wiki)

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
