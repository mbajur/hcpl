<template lang="pug">
  div
    .vux-demo
      h1 {{ msg }}

    group(title="cell demo")
      cell(title="VUX" value="cool" is-link)
</template>

<script>
import { Group, Cell } from 'vux'

export default {
  components: {
    Group,
    Cell
  },
}
</script>
