@wip @profile
Feature: 프로필 소셜 링크 주소 규칙
  프로필 편집 양식의 LinkedIn 주소, GitHub 주소, Twitter 주소 칸은 http나 https로 시작하는 주소만 받는다.
  화면과 서버가 같은 기준으로 확인하고, 칸을 비우면 그 링크 없이 저장된다.

  Background:
    Given 학생 "김민아"의 사용자 이름이 "minah"이다
    And 학생 "김민아"로 로그인되어 있다

  Rule: 소셜 링크 칸은 http나 https로 시작하는 주소만 받고 비우면 저장된다

    Scenario Outline: 소셜 링크 칸에 주소가 아닌 값을 넣고 저장하면 오류 알림이 보이고 저장되지 않는다
      Given 프로필 편집 양식의 <칸> <값> 넣었다
      When 저장 버튼을 누른다
      Then <칸 이름> http나 https로 시작하는 주소가 아니라는 오류 알림이 보이고 아무것도 저장되지 않는다

      Examples:
        | 칸                 | 값                   | 칸 이름         |
        | LinkedIn 주소 칸에 | "minah"를            | LinkedIn 주소가 |
        | GitHub 주소 칸에   | "github.com/minah"를 | GitHub 주소가   |
        | Twitter 주소 칸에  | "@minah"를           | Twitter 주소가  |

    Scenario: 소셜 링크에 주소가 아닌 값을 넣어 프로필을 고치도록 직접 요청해도 같은 이유로 거부된다
      When LinkedIn 주소를 "minah"로 바꿔 자기 프로필을 고치도록 직접 요청한다
      Then LinkedIn 주소가 http나 https로 시작하는 주소가 아니라는 이유로 요청이 거부된다
      And 학생 "김민아"의 LinkedIn 주소는 그대로이다

    Scenario: 소셜 링크 칸을 비우고 저장하면 그 링크 없이 저장되고 프로필에서 그 아이콘이 사라진다
      Given 학생 "김민아"의 LinkedIn 주소가 "https://www.linkedin.com/in/minah"이다
      And 프로필 편집 양식의 LinkedIn 주소 칸을 비웠다
      When 저장 버튼을 누른다
      Then 프로필을 저장했다는 알림이 보이고 학생 "김민아"의 프로필에 LinkedIn 아이콘이 없다
