<template>
  <div class="last-activity">
    <div class="table-responsive">
      <b-table striped hover :fields="fields" :items="extrinsics">
        <template #cell(block_number)="data">
          <p class="mb-0">
            <nuxt-link :to="`/block?blockNumber=${data.item.block_number}`">
              #{{ formatNumber(data.item.block_number) }}
            </nuxt-link>
          </p>
        </template>
        <template #cell(signer)="data">
          <p class="mb-0 d-inline-block">
            <Identicon
              :key="data.item.signer"
              :address="data.item.signer"
              :size="20"
            />
            <nuxt-link :to="`/account/${data.item.signer}`">
              {{ shortAddress(data.item.signer) }}
            </nuxt-link>
          </p>
        </template>
        <template #cell(section)="data">
          <p class="mb-0">
            {{ data.item.section }} ➡
            {{ data.item.method }}
          </p>
        </template>
      </b-table>
    </div>
  </div>
</template>

<script>
import commonMixin from '@/mixins/commonMixin.js'
import gql from 'graphql-tag'

export default {
  mixins: [commonMixin],
  data() {
    return {
      extrinsics: [],
      fields: [
        {
          key: 'block_number',
          label: 'Id',
          sortable: true,
        },
        {
          key: 'signer',
          label: 'Signer',
          class: 'd-none d-sm-none d-md-none d-lg-block d-xl-block',
          sortable: true,
        },
        {
          key: 'section',
          label: 'Extrinsic',
          sortable: true,
        },
      ],
    }
  },
  apollo: {
    $subscribe: {
      extrinsic: {
        query: gql`
          subscription extrinsics {
            extrinsic(
              order_by: { block_number: desc }
              where: { is_signed: { _eq: true } }
              limit: 10
            ) {
              block_number
              extrinsic_index
              is_signed
              signer
              section
              method
              hash
              doc
            }
          }
        `,
        result({ data }) {
          this.extrinsics = data.extrinsic
        },
      },
    },
  },
}
</script>

<style>
.last-activity .table th,
.last-activity .table td {
  padding: 0.45rem;
}
.last-activity .table thead th {
  border-bottom: 0;
}
.last-activity .identicon {
  display: inline-block;
  margin: 0 0.2rem 0 0;
  cursor: copy;
}
</style>
