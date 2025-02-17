<template>
  <div v-if="transfer" class="table-responsive pb-4">
    <table class="table table-striped transfer-table">
      <tbody>
        <tr>
          <td>Block number</td>
          <td>
            <nuxt-link :to="`/block?blockNumber=${transfer.block_number}`">
              #{{ formatNumber(transfer.block_number) }}
            </nuxt-link>
          </td>
        </tr>
        <tr>
          <td>Timestamp</td>
          <td>
            <p class="mb-0">
              {{ getDateFromTimestamp(transfer.timestamp) }}
            </p>
          </td>
        </tr>
        <tr>
          <td>Extrinsic</td>
          <td>
            <p class="mb-0">
              <nuxt-link
                v-b-tooltip.hover
                :to="`/extrinsic/${transfer.block_number}/${transfer.extrinsic_index}`"
                title="Check extrinsic information"
              >
                #{{ formatNumber(transfer.block_number) }}-{{
                  transfer.extrinsic_index
                }}
              </nuxt-link>
            </p>
          </td>
        </tr>
        <tr>
          <td>Hash</td>
          <td>
            {{ transfer.hash }}
          </td>
        </tr>
        <tr>
          <td>From</td>
          <td>
            <div v-if="transfer.signer">
              <Identicon
                :key="transfer.signer"
                :address="transfer.signer"
                :size="20"
              />
              <nuxt-link :to="`/account/${transfer.signer}`">
                {{ transfer.signer }}
              </nuxt-link>
            </div>
          </td>
        </tr>
        <tr>
          <td>To</td>
          <td>
            <div v-if="JSON.parse(transfer.args)[0].id">
              <Identicon
                :key="JSON.parse(transfer.args)[0].id"
                :address="JSON.parse(transfer.args)[0].id"
                :size="20"
              />
              <nuxt-link :to="`/account/${JSON.parse(transfer.args)[0].id}`">
                {{ JSON.parse(transfer.args)[0].id }}
              </nuxt-link>
            </div>
            <div v-if="JSON.parse(transfer.args)[0].address20">
              <eth-identicon
                :address="JSON.parse(transfer.args)[0].address20"
                :size="20"
              />
              <nuxt-link
                :to="`/account/${JSON.parse(transfer.args)[0].address20}`"
              >
                {{ JSON.parse(transfer.args)[0].address20 }}
              </nuxt-link>
            </div>
          </td>
        </tr>
        <tr>
          <td>Amount</td>
          <td class="amount">
            {{
              formatAmount(
                transfer.section === 'currencies'
                  ? JSON.parse(transfer.args)[2]
                  : JSON.parse(transfer.args)[1]
              )
            }}
          </td>
        </tr>
        <tr>
          <td>Fee</td>
          <td class="amount">
            <div v-if="transfer.fee_info">
              {{ formatAmount(JSON.parse(transfer.fee_info).partialFee) }}
            </div>
          </td>
        </tr>
        <tr>
          <td>Status</td>
          <td>
            <font-awesome-icon
              v-if="transfer.success"
              icon="check"
              class="text-success"
            />
            <font-awesome-icon v-else icon="times" class="text-danger" />
            <template v-if="!transfer.success">
              <Promised
                :promise="
                  getExtrinsicFailedFriendlyError(
                    transfer.block_number,
                    transfer.extrinsic_index,
                    $apollo.provider.defaultClient
                  )
                "
              >
                <template #default="data"
                  ><span class="text-danger ml-2">{{ data }}</span></template
                >
              </Promised>
            </template>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import { Promised } from 'vue-promised'
import commonMixin from '@/mixins/commonMixin.js'
export default {
  components: { Promised },
  mixins: [commonMixin],
  props: {
    transfer: {
      type: Object,
      default: () => undefined,
    },
  },
}
</script>
