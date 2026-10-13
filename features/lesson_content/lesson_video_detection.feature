@wip @lesson_content
Feature: 영상이 있는 레슨의 판단
  강좌 편집기는 레슨에 영상이 있을 때만 영상 통계 버튼을 보여 준다.
  올린 영상 파일의 형식은 대소문자를 가리지 않고 판단한다.

  Background:
    Given 강좌 "생물 입문"의 강사로 지정된 강사로 로그인되어 있다

  Rule: 영상 삽입 콘텐츠, 올린 영상 파일, 시청 기록이 있으면 영상이 있는 레슨이다
    영상 삽입 콘텐츠는 YouTube, Vimeo, Cloudflare Stream, Bunny Stream, Aparat 삽입 콘텐츠이다. 문서, 슬라이드, 코드를 보여 주는 삽입 콘텐츠는 영상이 아니다.

    Scenario Outline: 레슨 내용에 따라 영상 통계 버튼을 보여 줄지가 정해진다
      Given 레슨 "세포막"에 <레슨 내용> 있다
      When 강좌 편집기에서 레슨 "세포막"을 연다
      Then 머리글에 영상 통계 버튼이 <표시>

      Examples:
        | 레슨 내용                       | 표시          |
        | YouTube 삽입 콘텐츠가           | 보인다        |
        | Vimeo 삽입 콘텐츠가             | 보인다        |
        | Cloudflare Stream 삽입 콘텐츠가 | 보인다        |
        | Bunny Stream 삽입 콘텐츠가      | 보인다        |
        | Aparat 삽입 콘텐츠가            | 보인다        |
        | 올린 영상 파일 "분열.MP4"가     | 보인다        |
        | 올린 영상 파일 "분열.mov"가     | 보인다        |
        | 학생의 영상 시청 기록이         | 보인다        |
        | 문단과 제목만                   | 보이지 않는다 |
        | 올린 PDF 파일 "요약.pdf"만      | 보이지 않는다 |
        | 블록 형식이 아닌 글로 된 본문만 | 보이지 않는다 |
        | Google 문서 삽입 콘텐츠만       | 보이지 않는다 |
        | Google 슬라이드 삽입 콘텐츠만   | 보이지 않는다 |
        | CodeSandbox 삽입 콘텐츠만       | 보이지 않는다 |
        | GitHub Gist 삽입 콘텐츠만       | 보이지 않는다 |
