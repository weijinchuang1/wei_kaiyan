import FindViewModel from '../../viewmodel/FindViewModel';
import { CommonTopBar } from '../../views/CommonTopBar';
import { CategoryPage } from './category/Category';
import { FocusPage } from './focus/FocusPage';



@Entry
@Component
export struct FindPage {
  @Provide findCurrentIndex: number = 0
  @State message: string = 'Hello World';
  private controller: TabsController = new TabsController()
  build() {
          Column() {
            CommonTopBar({ title: "发现", backButton: false, alpha: 1 })
            Stack() {
              Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
                TabContent() {
                  FocusPage()
                }.tabBar(this.TabBuilder(0, FindViewModel.tabTitle[0].title || ""))
                TabContent() {
                  CategoryPage()
                }.tabBar(this.TabBuilder(1, FindViewModel.tabTitle[1].title || ""))
                TabContent() {

                }.tabBar(this.TabBuilder(2, FindViewModel.tabTitle[2].title || ""))
              }
              .barHeight($r("app.float.size_50"))
              .barMode(BarMode.Fixed)
              .onChange((index) => {
                this.findCurrentIndex = index
              })
            }
          }
          .width("100%")
          .height("100%")
        }
      @Builder
      TabBuilder(index: number, name: string) {
        Column() {
          Text(name)
            .fontColor(this.findCurrentIndex === index ? $r("app.color.color_white") : $r("app.color.color_f5f5f5"))
            .fontSize($r('app.float.size_text_15'))
            .fontWeight(this.findCurrentIndex === index ? 500 : 400)
            .height($r("app.float.size_45"))
            .flexGrow(1)
            .textAlign(TextAlign.Center)
          Divider()
            .strokeWidth(5)
            .color($r("app.color.color_white"))
            .opacity(this.findCurrentIndex === index ? 1 : 0)
            .width($r("app.float.size_80"))
            .lineCap(LineCapStyle.Round)
        }
        .width('101%') //解决Tab连接处白色线条间隙
        .height($r("app.float.size_50"))
        .backgroundColor($r("app.color.color_red"))
        .justifyContent(FlexAlign.Center)
      }
    }

function TopicPage() {
  throw new Error('Function not implemented.');
}
