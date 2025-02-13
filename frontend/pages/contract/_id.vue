<template>
  <div>
    <section>
      <b-container class="contract-page main py-5">
        <div v-if="loading" class="text-center py-4">
          <Loading />
        </div>
        <template v-else-if="!contract">
          <h1 class="text-center">Contract not found!</h1>
        </template>
        <template v-else>
          <div class="card mb-4">
            <div class="card-body">
              <h4 class="text-center mb-4">
                <eth-identicon :address="contractId" :size="32" />
                <span v-if="contract.name">
                  {{ contract.name }}
                </span>
                <span v-else>
                  {{ contractId }}
                </span>
                <b-badge
                  v-if="contract.is_erc20"
                  :to="`/token/${contract.contract_id}`"
                  class="ml-2"
                  variant="info"
                >
                  ERC-20 token
                </b-badge>
              </h4>
              <b-tabs content-class="mt-3">
                <b-tab title="General" active>
                  <div class="table-responsive pb-4">
                    <table class="table table-striped">
                      <tbody>
                        <tr>
                          <td>Contract address</td>
                          <td class="text-right">
                            <eth-identicon :address="contractId" :size="16" />
                            {{ contractId }}
                          </td>
                        </tr>
                        <tr>
                          <td>Created at block</td>
                          <td class="text-right">
                            <nuxt-link
                              :to="`/block?blockNumber=${contract.block_height}`"
                            >
                              #{{ formatNumber(contract.block_height) }}
                            </nuxt-link>
                          </td>
                        </tr>
                        <tr>
                          <td>{{ $t('details.contract.signer') }}</td>
                          <td class="text-right">
                            <div v-if="contract.signer">
                              <Identicon
                                :key="contract.signer"
                                :address="contract.signer"
                                :size="20"
                              />
                              <nuxt-link :to="`/account/${contract.signer}`">
                                {{ shortAddress(contract.signer) }}
                              </nuxt-link>
                            </div>
                          </td>
                        </tr>
                        <tr v-if="contract.value">
                          <td>{{ $t('details.contract.value') }}</td>
                          <td class="text-right">
                            {{ contract.value }}
                          </td>
                        </tr>
                        <tr v-if="contract.gas_limit">
                          <td>{{ $t('details.contract.gas_limit') }}</td>
                          <td class="text-right">
                            {{ contract.gas_limit }}
                          </td>
                        </tr>
                        <tr v-if="contract.storage_limit">
                          <td>{{ $t('details.contract.storage_limit') }}</td>
                          <td class="text-right">
                            {{ contract.storage_limit }}
                          </td>
                        </tr>
                        <tr v-if="contract.bytecode">
                          <td>{{ $t('details.contract.bytecode') }}</td>
                          <td class="text-right">
                            <span class="bytecode" style="color: #aaa">{{
                              contract.bytecode
                            }}</span>
                          </td>
                        </tr>
                        <tr>
                          <td>{{ $t('details.contract.verified') }}</td>
                          <td class="text-right">
                            <p v-if="contract.verified" class="mb-0">
                              <font-awesome-icon
                                icon="check"
                                class="text-success"
                              />
                            </p>
                            <p v-else class="mb-0">
                              <font-awesome-icon
                                icon="times"
                                class="text-danger"
                              />
                            </p>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </b-tab>
                <b-tab v-if="contract.verified" title="Developer">
                  <div class="table-responsive pb-4">
                    <table class="table table-striped">
                      <tbody>
                        <tr>
                          <td>{{ $t('details.contract.compiler_version') }}</td>
                          <td class="text-right">
                            {{ contract.compiler_version }}
                          </td>
                        </tr>
                        <tr>
                          <td>{{ $t('details.contract.optimization') }}</td>
                          <td class="text-right">
                            <p v-if="contract.optimization" class="mb-0">
                              <font-awesome-icon
                                icon="check"
                                class="text-success"
                              />
                            </p>
                            <p v-else class="mb-0">
                              <font-awesome-icon
                                icon="times"
                                class="text-danger"
                              />
                            </p>
                          </td>
                        </tr>
                        <tr>
                          <td>{{ $t('details.contract.runs') }}</td>
                          <td class="text-right">
                            {{ contract.runs }}
                          </td>
                        </tr>
                        <tr>
                          <td>{{ $t('details.contract.target') }}</td>
                          <td class="text-right">
                            {{ contract.target }}
                          </td>
                        </tr>
                        <tr>
                          <td>{{ $t('details.contract.license') }}</td>
                          <td class="text-right">
                            {{ contract.license }}
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </b-tab>
                <b-tab v-if="contract.verified" title="Verified source">
                  <pre>{{ contract.source }}</pre>
                </b-tab>
                <b-tab v-if="contract.verified" title="ABI">
                  <vue-json-pretty :data="JSON.parse(contract.abi)" />
                </b-tab>
                <b-tab title="Contract executions">
                  <contract-executions :contract-id="contractId" />
                </b-tab>
                <b-tab v-if="contract.verified" title="Contract call">
                  <contract-call
                    :contract-id="contractId"
                    :contract-name="contract.name"
                    :contract-abi="JSON.parse(contract.abi)"
                  />
                </b-tab>
              </b-tabs>
            </div>
          </div>
        </template>
      </b-container>
    </section>
  </div>
</template>
<script>
import gql from 'graphql-tag'
import Identicon from '@/components/Identicon.vue'
import Loading from '@/components/Loading.vue'
import commonMixin from '@/mixins/commonMixin.js'
import { network } from '@/frontend.config.js'
import VueJsonPretty from 'vue-json-pretty'
import ContractExecutions from '../../components/ContractExecutions.vue'

export default {
  components: {
    Identicon,
    Loading,
    VueJsonPretty,
    ContractExecutions,
  },
  mixins: [commonMixin],
  data() {
    return {
      network,
      loading: true,
      contractId: this.$route.params.id,
      contract: undefined,
    }
  },
  watch: {
    $route() {
      this.contractId = this.$route.params.id
    },
  },
  apollo: {
    $subscribe: {
      contract: {
        query: gql`
          subscription contract($contract_id: String!) {
            contract(where: { contract_id: { _eq: $contract_id } }) {
              contract_id
              name
              bytecode
              value
              gas_limit
              storage_limit
              signer
              block_height
              verified
              source
              compiler_version
              optimization
              runs
              target
              abi
              license
              is_erc20
              timestamp
            }
          }
        `,
        variables() {
          return {
            contract_id: this.contractId,
          }
        },
        result({ data }) {
          if (data.contract[0]) {
            this.contract = data.contract[0]
          }
          this.loading = false
        },
      },
    },
  },
}
</script>

<style>
.contract-page .bytecode {
  word-break: break-all;
}
</style>
