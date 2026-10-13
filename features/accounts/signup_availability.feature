@wip @accounts
Feature: 가입 허용 여부
  방문자가 스스로 계정을 만들 수 있는지는 관리자가 정하는 가입 비활성화 설정과 가입 속도 제한에 따른다.
  가입 요청은 이메일, 전체 이름, 약관 동의 여부, 사용자 범주를 받는다.

  Background:
    Given 로그인하지 않았다

  Rule: 가입 비활성화 설정이 켜져 있을 때만 가입을 받지 않는다
    가입 비활성화 설정의 기본값은 꺼짐이어서 설정을 바꾸지 않은 사이트는 가입을 받는다.

    Scenario: 설정을 바꾼 적이 없는 사이트는 가입을 받는다
      Given 사이트 설정을 한 번도 바꾸지 않았다
      When 이메일 "minah@example.test", 전체 이름 "김민아"로 가입한다
      Then 이메일 "minah@example.test"의 계정이 만들어진다

    Scenario: 가입 비활성화가 켜진 사이트는 안내와 함께 가입을 거부한다
      Given 설정 "가입 비활성화"가 켜져 있다
      When 이메일 "minah@example.test", 전체 이름 "김민아"로 가입한다
      Then 가입이 비활성화되어 있다는 안내와 함께 가입이 거부된다
      And 이메일 "minah@example.test"의 계정은 만들어지지 않는다

    Scenario Outline: 가입 비활성화 설정에 따라 계정 생성 여부가 정해진다
      Given 설정 "가입 비활성화"가 <설정 상태>
      When 이메일 "minah@example.test", 전체 이름 "김민아"로 가입한다
      Then 이메일 "minah@example.test"의 계정이 <생성 여부>

      Examples:
        | 설정 상태 | 생성 여부         |
        | 켜져 있다 | 만들어지지 않는다 |
        | 꺼져 있다 | 만들어진다        |

    Scenario: 관리자가 가입 비활성화를 끄면 별도 저장 없이 바로 가입을 받는다
      Given 설정 "가입 비활성화"가 켜져 있다
      And 관리자 "정하늘"이 설정 창의 가입 탭에서 가입 비활성화를 껐다
      When 이메일 "minah@example.test", 전체 이름 "김민아"로 가입한다
      Then 이메일 "minah@example.test"의 계정이 만들어진다

  Rule: 같은 이메일의 계정은 하나만 존재한다

    Background:
      Given 설정 "가입 비활성화"가 꺼져 있다

    Scenario: 사용 중인 계정의 이메일로 가입하면 로그인하라는 안내가 표시된다
      Given 이메일 "minah@example.test"인 사용 중인 계정이 있다
      When 이메일 "minah@example.test", 전체 이름 "김민아"로 가입한다
      Then 이미 가입되어 있으니 로그인하라는 안내가 오류로 표시된다
      And 안내 안의 로그인 링크로 로그인 화면에 갈 수 있다
      And 새 계정은 만들어지지 않는다

    Scenario: 비활성화된 계정의 이메일로 가입하면 가입은 되어 있으나 비활성화되었다는 안내가 표시된다
      Given 이메일 "minah@example.test"인 비활성화된 계정이 있다
      When 이메일 "minah@example.test", 전체 이름 "김민아"로 가입한다
      Then 가입은 되어 있으나 계정이 비활성화되어 있다는 안내가 오류로 표시된다
      And 새 계정은 만들어지지 않는다

    Scenario: 같은 이메일로 거의 동시에 가입하면 계정은 하나만 만들어진다
      When 두 방문자가 이메일 "minah@example.test"로 거의 동시에 가입한다
      Then 이메일 "minah@example.test"의 계정은 하나만 있다
      And 늦게 처리된 방문자에게는 이미 가입되어 있다는 안내가 표시된다

  Rule: 최근 60분 동안 만들어진 계정 수가 시간당 최대 가입 수에 이르면 가입을 받지 않는다
    시간당 최대 가입 수는 사이트에 정해진 값이며 정해지지 않았으면 300이다.
    가입 경로와 관계없이 최근 60분 동안 만들어진 모든 계정을 센다.

    Background:
      Given 설정 "가입 비활성화"가 꺼져 있다
      And 시간당 최대 가입 수가 정해져 있지 않다

    Scenario Outline: 최근 60분 동안 만들어진 계정 수에 따라 계정 생성 여부가 정해진다
      Given 최근 60분 동안 만들어진 계정이 <계정 수>개이다
      When 이메일 "minah@example.test", 전체 이름 "김민아"로 가입한다
      Then 이메일 "minah@example.test"의 계정이 <생성 여부>

      Examples:
        | 계정 수 | 생성 여부         |
        | 299     | 만들어진다        |
        | 300     | 만들어지지 않는다 |

    Scenario: 가입이 일시적으로 막히면 한 시간 뒤에 다시 시도하라는 안내가 표시된다
      Given 최근 60분 동안 만들어진 계정이 300개이다
      When 이메일 "minah@example.test", 전체 이름 "김민아"로 가입한다
      Then 최근 가입이 많아 가입이 잠시 중단되었으니 한 시간 뒤에 다시 시도하라는 안내가 표시된다
