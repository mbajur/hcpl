<template lang="pug">
  form

    .alert.alert-danger.mb-4(v-if="fullErrorMessages.length > 0")
      h5.alert-heading Coś poszło nie tak:
      ul.mb-0
        li(v-for="error in fullErrorMessages")
          | {{ error }}

    input(type="hidden" name="utf8" value="✓")
    input(type="hidden" name="authenticity_token" :value="csrfToken")

    .form-group.row
      label.col-sm-3.col-form-label.post_link(for="post_link") Link
      .col-sm-9
        .row
          .col-9
            input.form-control(type="text" autofocus placeholder="http://..." name="post[link]" id="post_link" v-model="form.link")

          .col-3
            button.btn.btn-outline-secondary.btn-block(@click.prevent="fetchLinkData" :disabled="isFetchLinkDisabled")
              template(v-if="fetchingLink")
                | Momencik...
              template(v-else)
                | Pobierz tytuł

    .form-group.row
      label.col-sm-3.col-form-label.post_link(for="post_title")
        | {{ titleLabel }}
      .col-sm-9
        input.form-control(type="text" name="post[title]" id="post_title" v-model="form.title")

    .form-group.row(v-if="!hideTags")
      label.col-sm-3.col-form-label.post_link(for="post_tag_list") Tagi
      .col-sm-9
        input.form-control(type="hidden" :value="form.tag_list" name="post[tag_list]" id="post_tag_list")
        multiselect(
          v-model="form.tag_list"
          :options="tagsInputOptions"
          :multiple="true"
          :taggable="true"
          tag-placeholder="Dodaj jako nowy tag",
          placeholder="Szukaj lub dodaj tag"
          select-label="Wciśnij enter aby wybrać"
          deselect-label="Wciśnij enter aby usunąć"
          selected-label="Zaznaczony"
          @tag="addTag"
          :hide-selected="true"
          :max="5"
          @search-change="handleTagsSearchChange"
        )
        small.form-text.text-muted Wybierz do pięciu tagów opisujących ten post

    .form-group.row(v-if="!hideDescription")
      label.col-sm-3.col-form-label.post_link(for="post_description") Tekst
      .col-sm-9
        textarea.form-control(type="text" name="post[description]" id="post_description" placeholder="Niewymagany jeśli wysyłasz linka" v-model="form.description")

    .form-group.row.mb-0
      label.col-sm-3.col-form-label
      .col-sm-9
        input.btn.btn-success(type="submit" value="Dodaj post")

</template>

<script>
import Multiselect from 'vue-multiselect'

let cloneString = function (val) {
  return JSON.parse(JSON.stringify(val))
}

export default {
  props: {
    csrfToken: String,
    fullErrorMessages: Array,
    postTags: Array,
    tags: Array,
    post: {
      type: Object,
      default: () => { return {
        link: '',
        title: '',
        tag_list: '',
        description: ''
      }}
    },
    hideTags: {
      type: Boolean,
      default: false
    },
    hideDescription: {
      type: Boolean,
      default: false
    },
    titleLabel: {
      type: String,
      default: 'Tytuł posta'
    }
  },

  components: {
    Multiselect
  },

  data () {
    return {
      fetchingLink: false,
      form: {
        link: cloneString(this.post.link),
        title: cloneString(this.post.title),
        tag_list: (this.post.tag_list !== null && this.post.tag_list.trim() !== '') ? this.post.tag_list.split(',') : [],
        description: cloneString(this.post.description),
      },
      fetchedTags: []
    }
  },

  methods: {
    fetchLinkData () {
      this.fetchingLink = true

      let req = this.$http.post('posts/fetch_title', { link: this.form.link })

      req.then((resp) => {
        this.form.title = resp.data.title
        this.fetchingLink = false
      })

      req.catch(() => {
        alert('Ups! Coś poszło nie tak. Spróbuj ponownie za chwilę.')
        this.fetchingLink = false
      })
    },

    addTag (newTag) {
      this.tagsInputOptions.push(newTag)
      this.form.tag_list.push(newTag)
    },

    handleTagsSearchChange (query) {
      if (query.length == 0) { return false }
      let req = this.$http.get('tags', { params: { q: query } })

      req.then((resp) => {
        this.fetchedTags = resp.data.map((t) => { return t.name })
      })
    }
  },

  computed: {
    isFetchLinkDisabled () {
      return this.fetchingLink
    },

    tagsInputOptions () {
      return Array.from(new Set(this.tags.concat(this.fetchedTags))) || []
    }
  }
}
</script>

<style>
@import url(vue-multiselect/dist/vue-multiselect.min.css);

.multiselect__tags {
  border-color: #ced4da;
}
</style>
