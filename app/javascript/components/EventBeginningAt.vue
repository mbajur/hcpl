<template lang="pug">
  span
    template(v-if="label")
      | {{ label }}
    template(v-else)
      human-date-time(:date-time="dateTime")
</template>

<script>
import moment from 'moment'
import HumanDateTime from '../components/HumanDateTime.vue'

export default {
  props: {
    dateTime: {
      type: String,
      default: new Date()
    }
  },

  components: {
    HumanDateTime
  },

  data () {
    return {
      date: new Date(this.dateTime)
    }
  },

  computed: {
    today () {
      return moment()
    },

    label () {
      if (this.isToday) {
        return 'Dzisiaj'
      } else if (this.isTomorrow) {
       return 'Jutro'
      } else if (this.isDayAfterTomorrow) {
       return 'Pojutrze'
      } else if (this.isYesterday) {
       return 'Wczoraj'
      } else {
        return false
      }
    },

    isToday () {
      let today = moment()
      return moment(this.date).isSame(today, 'day')
    },

    isTomorrow () {
      let tomorrow = moment().add(1, 'day')
      return moment(this.date).isSame(tomorrow, 'day')
    },

    isDayAfterTomorrow () {
      let dayAfterTomorrow = moment().add(2, 'day')
      return moment(this.date).isSame(dayAfterTomorrow, 'day')
    },

    isYesterday () {
      let yesterday = moment().subtract(1, 'day')
      return moment(this.date).isSame(yesterday, 'day')
    }
  }
}
</script>
