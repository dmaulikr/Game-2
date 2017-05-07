[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://www.apple.com/ios/ios-10/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://mit-license.org)

# Game

### SpriteKit, animation, physicsbody. 

Практика применения `SpriteKit` для создания игры, использующей широкий диапазон приёмов, 
начиная с `SKPhysicsBody` и заканчивая `ParticleEffect`. Стартовый splash-screen сопровождается музыкальным фрагментом, далее переход осуществляется к краткому поясняющему описанию. 

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/23423988/22820723/12bf9762-ef89-11e6-985e-f404c5f8cf71.png" alt="Image") />
  <img src="https://cloud.githubusercontent.com/assets/23423988/22820727/167318c0-ef89-11e6-907f-b7198dd9510f.png" alt="Image") />
</p> 

Основная сцена: в центре экрана расположен главный герой, стоящий за орудием. Сверху появляются враги, падение которых 
необходимо предотвратить выстрелом. Он осуществляется нажатием (`TapGesture`) в соответствующую часть экрана. 
  
Контакт снаряда и врага сопвровождаются взрывом (`ParticleEffect`). А также, на месте появляются "осколки", разлетающиеся в стороны и падающие под действием гравитации. Каждое попадание добавляет 125 очков к Score. 
Выстрел и collision имеют звуковое сопровождение.   

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/23423988/23330613/0cddc586-fb63-11e6-8604-c2931a5ca0eb.gif" alt="Image") />
</p>

Для придания игре возрастающей сложности, скорость движения врагов и частота их появления увеличиваются. 
Если враг коснулся земли, герой теряет одну жизнь (affects HUD). Сценарий Game Over и соответствующий аудиофрагмент воспроизводятся при отсутствии жизней. Враги перестают появляться, происходит сравнение текущего Score с HighScore и вывод на экран наибольшего значения. Следующий Tap снова воспроизводит main game scene. 

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/23423988/22820733/1bfc005e-ef89-11e6-8c57-93c805c2a6a8.png" alt="Image") />
</p>

## Used  

- SpriteKit (`SKAction`, `SKSpriteNode`, `SKPhysicsBody`, `SKEmitter`)
- .atlas файл для работы с картинками
- `NSTimeInterval` для изменения уровня сложности
- `AVAudioPlayer` для звукового сопровождения
- `NSUserDefaults` для хранения HighScore
- `animateWithTextures` для покадровой анимации. 

## To do

- [x] Add music and sound
- [ ] Add pause and disable music buttons
- [ ] Hero and enemies animation

## License

Game is available under the MIT license. See the LICENSE file for more info.
