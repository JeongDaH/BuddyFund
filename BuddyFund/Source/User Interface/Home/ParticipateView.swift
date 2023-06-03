//
//  ParticipateView.swift
//  BuddyFund
//
//  Created by 정다혜 on 2023/05/15.
//

import SwiftUI

struct ParticipateView: View {
    let product : Product
    @State var amount: String = ""
    @State private var showingAlert = false
    @State private var showingPopup = false
    @State var message: String = ""
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Text(product.title).font(.largeTitle).bold().frame(height:140,alignment:.bottom)
                Text(product.username+"님의 생일 : "+calculateBirthdayDday(birthday: product.bday))
                    .font(.title)
                    .padding([.vertical])
                HStack{
                    Text("현재진행률")
                        .font(.title3)
                    Spacer()
                    Text("\(product.currentCollection)/\(product.price)")
                        .font(.title3)
                }.padding([.vertical])
                ProgressBar(progress: (Double(product.currentCollection)/Double(product.price))*100)
                    .frame(height: 20)
                TextField("펀딩할 금액을 입력하세요",text: $amount)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 6).stroke())
                Text("입력된 금액 : "+stringNumberComma(number:amount))
                    .font(.title2)
                TextEditor(text: $message)
                    .font(Font.title3)
                    .frame(height: 150)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke())
                    .overlay(Text("생일 축하 메세지를 남겨주세요~!")
                        .padding()
                        .foregroundColor(.gray)
                        .opacity(message.isEmpty ? 0.7 : 0), alignment: .topLeading
                        )
                Button(action: {
                    if stringNumberComma(number: amount) != "" {
                        self.showingAlert.toggle()
                    }
                }) {
                    Capsule()
                        .fill(Color.indigo).opacity(0.4)
                        .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 50)
                        .overlay(Text("펀딩하기")
                            .font(.system(size: 20)).fontWeight(.medium)
                            .foregroundColor(Color.black))
                        .padding(.vertical, 8)
                }.buttonStyle(ShrinkButtonStyle())
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("금액 확인"),
                          message: Text("\(product.username)님께 \(stringNumberComma(number:amount))원을 펀딩하시겠습니까?\n펀딩메세지:\(message)"),
                          primaryButton: .default(
                            Text("펀딩하기"),
                            action: {
                                showingPopup.toggle()
                            }),
                          secondaryButton: .cancel(Text("취소")))
                }
                Spacer()
            }
            .padding()
//            .navigationTitle(product.title)
            .edgesIgnoringSafeArea([.vertical])
            .popup(isPresented: $showingPopup){Text("✦ 펀딩완료 ✧").font(.system(size:24)).bold().multilineTextAlignment(.center)}
        }

    }
}
private extension ParticipateView {
    func calculateBirthdayDday(birthday: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMdd"
        
        // 현재 날짜
        let currentDate = Date()
        var currentDateString = dateFormatter.string(from: currentDate)

        // 올해의 생일
        let currentYear = Calendar.current.component(.year, from: currentDate)

        // 생일이 지난 경우 내년 생일로 계산
        var nextBirthdayDateString = "\(currentYear)\(birthday)"
        dateFormatter.dateFormat = "YYYYMMdd"
        if let nextBirthdayDate = dateFormatter.date(from: nextBirthdayDateString){
            dateFormatter.dateFormat = "YYYYMMdd"
            currentDateString = dateFormatter.string(from: currentDate)
            nextBirthdayDateString = dateFormatter.string(from: nextBirthdayDate)

            if nextBirthdayDateString < currentDateString {
            nextBirthdayDateString = "\(currentYear + 1)\(birthday)"
        }
            else if nextBirthdayDateString == currentDateString {
                return "D-day"
            }
        }
        dateFormatter.dateFormat = "YYYYMMdd"
        // 날짜 계산
        let calendar = Calendar.current
        let birthdayDate = dateFormatter.date(from: nextBirthdayDateString)!
        let components = calendar.dateComponents([.day], from: currentDate, to: birthdayDate)
        dateFormatter.dateFormat = "YYYY"
        let c = nextBirthdayDateString.index(nextBirthdayDateString.startIndex,offsetBy: 3)
        if (Int(nextBirthdayDateString[nextBirthdayDateString.startIndex...c]) == currentYear)
        {
            let daysUntilBirthday = components.day!+1
            return("D-\(daysUntilBirthday)")
        }
        let daysUntilBirthday = components.day!
        
        return "D-\(daysUntilBirthday)"
    }
    func stringNumberComma(number: String)->String{
        let temp = Int(number)
        var tempString = ""
        var result = ""
        if let convertedNumber = temp {
            if convertedNumber<0 {
                return "0보다 큰 값을 입력하세요."
            }
            tempString = String(convertedNumber)
            var sIndex = tempString.index(tempString.startIndex,offsetBy: 0)
            var eIndex = tempString.index(tempString.startIndex,offsetBy: 1)
            for i in 0..<tempString.count{
                result += tempString[sIndex..<eIndex]
                if ((tempString.count-1-i) % 3 == 0)&&(tempString.count-1 != i){
                    result+=","
                }
                sIndex = eIndex
                eIndex = tempString.index(sIndex,offsetBy: 1,limitedBy: tempString.endIndex) ?? sIndex
            }
        }
        return result
    }
}

struct ParticipateView_Previews: PreviewProvider {
    static var previews: some View {
        ParticipateView(product: productSamples[0])
    }
}
