<template lang="pug">
  span
    | {{ dateTime | moment("from", "now") }}
</template>

<script>
export default {
  props: {
    dateTime: {
      type: String,
      default: new Date()
    }
  }
}
</script>
