
The application will require you to install the pods necessary for the app to run.

1. Use terminal to cd towards the product directory, then use: pod init
2. Open the podfile and paste the following:

platform :ios, '9.0'

target 'Todoie' do
    
pod 'RealmSwift', '~>10'
pod 'SwipeCellKit'
end

3. Use: pod install

The app will work once the pods are installed.
