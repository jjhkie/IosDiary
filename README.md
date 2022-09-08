# IosDiary

# [ 사용한 기술 ]

  - UITabBarController

  - UICollectionView
  
  - NotificationCenter
  
  - UserDefaults


# [ Point ]

  - Delegate 로 ViewController 간에 data 를 전달할 수 있다.
    
    data 를 보내는 ViewController : A
    
    data 를 받는 ViewController : B
    
    즉, Data 는 B -> A 로 보내는 것이다.

       1. A 에 delegate Property 를 선언하고, 데이터가 들어간 파라미터를 가진 Protocol 을 선언해준다.
       
       2. B 에서 delegate 대리자를 위임해주고, A 에서 선언해준 protocol 을 채택해준다.
       
       3. 채택한 Protocol 의 메서드를 구현하여 데이터를 받는다. 

  - view.endEditing(true) 를 사용하여 keyboard & Picker 가 사라지도로 설정할 수 있다.
  
  - Notification 등록 및 반응 
      
      등록 : addObserver( )

      알림 : postNotification( )
