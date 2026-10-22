import Notification from "@stimulus-components/notification"

export default class extends Notification {
  show() {
    this.enter()
    if (this.delayValue > 0) this.timeout = setTimeout(this.hide, this.delayValue)
  }
}
