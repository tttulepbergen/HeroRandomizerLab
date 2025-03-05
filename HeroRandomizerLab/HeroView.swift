import SwiftUI

struct HeroView: View {
    @State private var hero: Hero?
    @State private var showDetails = false
    @State private var isButtonPressed = false // Состояние для анимации
    @Environment(\.colorScheme) var colorScheme
    
    let viewModel: HeroViewModel // Экземпляр HeroViewModel
    
    var body: some View {
        ZStack {
            // Градиент на весь экран
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea() // Растягиваем на весь экран, включая Safe Area
            
            ScrollView {
                VStack(spacing: 0) {
                    if let hero = hero {
                        // Изображение героя с тенью и параллакс-эффектом
                        GeometryReader { geometry in
                            AsyncImage(url: URL(string: hero.images.lg)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView() // Индикатор загрузки
                                        .frame(width: geometry.size.width, height: 200)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: 200)
                                        .offset(y: -geometry.frame(in: .global).minY * 0.5)
                                case .failure:
                                    Image(systemName: "person.circle.fill") // Fallback изображение
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: 200)
                                        .offset(y: -geometry.frame(in: .global).minY * 0.5)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        .frame(height: 200)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        
                        Text(hero.name)
                            .font(.custom("Avenir-Black", size: 28))
                            .bold()
                            .padding()
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Full Name: \(hero.biography.fullName)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Place of Birth: \(hero.biography.placeOfBirth)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Гистограммы с градиентами и иконками
                            PowerStatBar(title: "Intelligence", value: hero.powerstats.intelligence ?? 0, color: .blue, icon: "brain")
                            PowerStatBar(title: "Strength", value: hero.powerstats.strength ?? 0, color: .red, icon: "bolt.fill")
                            PowerStatBar(title: "Speed", value: hero.powerstats.speed ?? 0, color: .green, icon: "hare.fill")
                            PowerStatBar(title: "Durability", value: hero.powerstats.durability ?? 0, color: .orange, icon: "shield.fill")
                            PowerStatBar(title: "Power", value: hero.powerstats.power ?? 0, color: .purple, icon: "star.fill")
                            PowerStatBar(title: "Combat", value: hero.powerstats.combat ?? 0, color: .pink, icon: "cross.fill")
                        }
                        .padding([.leading, .trailing])
                    } else {
                        Text("Нажмите кнопку, чтобы получить героя!")
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    // Кнопка с тенью и анимацией
                    Button(action: {
                        // Анимация при нажатии
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isButtonPressed = true
                        }
                        
                        // Задержка для возврата к исходному состоянию
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                isButtonPressed = false
                            }
                        }
                        
                        // Загрузка нового героя через viewModel
                        viewModel.fetchRandomHero { hero in
                            self.hero = hero
                        }
                    }) {
                        Text("New Hero")
                            .font(.title2)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .scaleEffect(isButtonPressed ? 0.95 : 1.0) // Анимация масштаба
                    }
                    .padding()
                }
            }
        }
        .onAppear(perform: loadRandomHero)
    }

    private func loadRandomHero() {
        // Загрузка героя через viewModel
        viewModel.fetchRandomHero { hero in
            self.hero = hero
        }
    }
}

struct PowerStatBar: View {
    var title: String
    var value: Int
    var color: Color
    var icon: String // Иконка для характеристики
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
            }
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(color.opacity(0.3))
                    .frame(width: CGFloat(value) * 3, height: 20) // Увеличиваем ширину и высоту гистограммы
                    .cornerRadius(10) // Закругляем углы
                
                Text("\(value)")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .padding(.leading, 8)
            }
        }
        .padding(.bottom, 12) // Увеличиваем отступ между гистограммами
    }
}

#Preview {
    HeroView(viewModel: HeroViewModel())
}
