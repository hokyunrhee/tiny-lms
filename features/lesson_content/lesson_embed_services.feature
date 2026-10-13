@wip @lesson_content
Feature: 삽입 콘텐츠 블록 만들기
  지원하는 서비스의 주소를 블록에 붙여 넣으면 그 콘텐츠를 레슨 안에서 보여 주는 삽입 콘텐츠 블록이 된다.

  Rule: 지원하는 서비스의 주소를 붙여 넣으면 삽입 콘텐츠 블록이 된다

    Background:
      Given 강좌 "생물 입문"의 강사로 지정된 강사로 로그인되어 있다
      And 강좌 편집기에서 레슨 "세포막"을 열고 본문의 빈 텍스트 블록에 커서를 두었다

    Scenario Outline: 서비스별 주소 형식을 붙여 넣으면 그 서비스의 삽입 콘텐츠 블록이 된다
      When <서비스> 주소를 붙여 넣는다
      Then 그 서비스의 삽입 콘텐츠 블록이 들어간다
      And 그 블록에는 설명을 적을 칸이 있다

      Examples:
        | 서비스                   |
        | YouTube 시청             |
        | YouTube 짧은             |
        | Vimeo 영상               |
        | Cloudflare Stream 시청   |
        | Bunny Stream 재생        |
        | Aparat 영상              |
        | Google 슬라이드 게시     |
        | Google 슬라이드 편집     |
        | Google Drive 파일 보기   |
        | Google 문서 편집         |
        | Google 스프레드시트 편집 |
        | CodeSandbox              |
        | CodePen                  |
        | GitHub Gist              |

    Scenario: 지원하지 않는 사이트의 주소는 삽입 콘텐츠 블록이 되지 않는다
      When 지원하지 않는 사이트의 주소를 붙여 넣는다
      Then 삽입 콘텐츠 블록은 들어가지 않는다
