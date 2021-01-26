# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# アセットパイプライン = 複数のディレクトリやファイルに分かれたassetsディレクトリ内のファイルをひとつに連結・圧縮する機能
# コンパイル = CoffeeScriptとか、SCSSとか、ブラウザが直接は読めない形式のファイルを、JSやCSSに変換してあげること
# プリコンパイル = rails serverが走るよりも前にコンパイルすること
# precompileをかけない状態でサーバーをproductionモードで起動すると、JSやCSSが存在せず、エラーになってしまう
# application.jsやcssは書かなくてもprecompileされている
Rails.application.config.assets.precompile += %w[mypage.js mypage.css]
