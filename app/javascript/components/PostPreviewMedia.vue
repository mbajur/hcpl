<template lang="pug">
  div
    .post-preview-media(v-if="show")
      .post-preview-media-youtube(v-if="type === 'youtube'")
        iframe(
          width="560"
          height="315"
          :src="youtubeSrc"
          frameborder="0"
          allowfullscreen
        )

      .post-preview-media-youtube(v-if="type === 'bandcamp_album'")
        iframe(
          style="border: 0; width: 100%; height: 120px;"
          :src="bandcampAlbumSrc"
          seamless
        )
</template>

<script>
export default {
  props: {
    postToken: String,
    type: String,
    guid: String,
    autoShow: {
      type: Boolean,
      default: false
    }
  },

  data () {
    return {
      show: false,
      autoPlay: true
    }
  },

  mounted () {
    if (this.autoShow) {
      this.show = true
      this.autoPlay = false
    }

    this.$eventHub.on('post:preview:toggle', (data) => {
      if (data.token === this.postToken) { this.show = !this.show }
    })
  },

  methods: {
  },

  computed: {
    youtubeSrc () {
      return `https://www.youtube.com/embed/${this.guid}?${this.autoPlay ? 'autoplay=1' : ''}`
    },

    bandcampAlbumSrc () {
      return `https://bandcamp.com/EmbeddedPlayer/album=${this.guid}/size=large/bgcol=ffffff/linkcol=0687f5/tracklist=false/artwork=small/transparent=true/`
    }
  }
}
</script>
