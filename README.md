# HaruDam  
오늘의 감정을 기록하고 건강한 루틴을 이어갈 수 있도록 돕는 감정 기록 iOS 앱


## 🧩 주요 기능
- **감정 기록**
  - 이모지(😌 😊 😢 😡 😰 🤔 🥰 🤯) 선택 + 간단 메모 저장
  - 당일 기록 중심 UX
- **기록 조회**
  - 리스트/카드 UI로 감정 기록 확인
  - 기록 상세 화면에서 내용 확인
- **홈 대시보드**
  - 최근 담은 감정 카드
  - 사용자 기록/통계 요약(예: 총 기록 수, 연속 기록 등)
- **프로필/설정**
  - 프로필 카드 UI
  - 알림/앱 설정 화면 구성

> 동기화 관련: 로컬에 먼저 저장하고, 네트워크 가능 시 서버(Supabase)와 상태를 맞추는 방식으로 설계


## 🛠️ 기술 스택
### 핵심 기술
- Swift
- SwiftUI
- iOS 15.0+
### 아키텍처 & 디자인 패턴
- Clean Architecture
- MVVM

### 개발 도구
- **Tuist** - 모듈화된 프로젝트 구조 관리 및 의존성 관리
- Xcode

### 데이터베이스 & 백엔드
- CoreData - 로컬 데이터 저장
- Supabase - 백엔드 서비스

### 테스트
- XCTest


## 📁 프로젝트 구조
```text
HaruDam/
├── Products/
│   ├── HaruDam/
│   └── HaruDamTests/
│
└── Project/
    ├── Derived/                    # 빌드 생성 파일
    ├── InfoPlists/                 # Info.plist 파일들
    ├── Sources/                    # 소스 코드
    │   └── HaruDam/
    │       ├── Repository/         # 데이터 저장소 계층
    │       ├── Shared/            # 공유 리소스 및 유틸리티
    │       ├── Components/        # 재사용 가능한 UI 컴포넌트
    │       ├── Config/            # 앱 설정 파일
    │       ├── CoreData/          # CoreData 모델 및 관리
    │       ├── Domain/            # 비즈니스 로직 및 엔티티
    │       ├── Features/          # 기능별 모듈
    │       │   ├── Profile/       # 프로필 화면
    │       │   ├── Record/        # 기록 화면
    │       │   ├── Home/          # 홈 화면
    │       │   ├── SignUp/        # 회원가입 화면
    │       │   └── Splash/        # 스플래시 화면
    │       ├── Managers/          # 각종 매니저 클래스
    │       ├── Resources/         # 리소스 파일 (이미지, 폰트 등)
    │       ├── Services/          # 외부 서비스 연동
    │       ├── Utils/             # 유틸리티 함수 및 헬퍼
    │       ├── HaruDamApp/        # 앱 진입점
    │       └── Info/              # 앱 정보
    │
    └── HaruDamTests/
        ├── SupabaseConnectionTests/      # Supabase 연결 테스트
        └── UserProfileCoreDataTests/     # CoreData 테스트
```

## 🧰 실행방법
- Tuist
```text
# 1) Tuist 설치 (미설치 시)
brew install tuist

# 2) 프로젝트 생성
tuist install
tuist generate

# 3) 실행
open HaruDam.xcworkspace
```
