<template lang="pug">
  a.btn.posts-item-vote.btn-post-vote(
    href="#"
    @click.prevent="toggleVote"
    :class="{ 'btn-post-vote--voted': vm.voted }"
  )
    | {{ vm.votesCount }}
</template>

<script>
export default {
  props: {
    postGuid: String,
    votesCount: Number,
    voted: {
      type: Boolean,
      default: false
    }
  },

  data () {
    return {
      vm: {
        votesCount: this.votesCount,
        voted: this.voted
      }
    }
  },

  methods: {
    toggleVote () {
      let req = this.$http.post(`posts/${this.postGuid}/toggle_vote`)

      req.then((resp) => {
        this.vm.votesCount = resp.data.votes_count
        this.vm.voted = resp.data.voted
      })
    }
  }
}
</script>
