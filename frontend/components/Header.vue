<template>
  <b-navbar toggleable="xl">
    <b-container class="px-sm-3">
      <b-navbar-brand>
        <nuxt-link to="/" class="navbar-brand" title="Reef block explorer">
          <img class="logo" src="/img/reef-logo-new.svg" />
          <span class="explorer">SCAN</span>
        </nuxt-link>
      </b-navbar-brand>
      <a
        v-if="network.coinGeckoDenom && USDConversion && USD24hChange"
        href="https://coinmarketcap.com/currencies/reef/"
        target="_blank"
        class="fiat mh-2"
      >
        <strong>{{ network.tokenSymbol }}</strong> ${{ USDConversion }} ({{
          USD24hChange
        }}%)
      </a>
      <b-navbar-toggle target="nav-collapse" />
      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav class="ml-auto">
          <b-nav-item right to="/blocks">Blocks</b-nav-item>
          <b-nav-item right to="/transfers">Transfers</b-nav-item>
          <b-nav-item right to="/extrinsics">Extrinsics</b-nav-item>
          <b-nav-item right to="/events">Events</b-nav-item>
          <b-nav-item right to="/accounts">Accounts</b-nav-item>
          <b-nav-item right to="/contracts">Contracts</b-nav-item>
          <b-nav-item right to="/tokens">Tokens</b-nav-item>
        </b-navbar-nav>
        <b-dropdown class="my-md-2 ml-md-2 network" variant="primary2">
          <template #button-content>
            <font-awesome-icon icon="plug" />
            {{ network.name }}
          </template>
          <b-dropdown-item href="https://testnet.reefscan.com"
            >Reef Testnet</b-dropdown-item
          >
          <b-dropdown-item href="https://reefscan.com"
            >Reef Mainnet</b-dropdown-item
          >
        </b-dropdown>
      </b-collapse>
    </b-container>
  </b-navbar>
</template>

<script>
import { network } from '@/frontend.config.js'
export default {
  data() {
    return {
      network,
    }
  },
  computed: {
    USDConversion() {
      return parseFloat(this.$store.state.fiat.usd).toFixed(3)
    },
    USD24hChange() {
      return parseFloat(this.$store.state.fiat.usd_24h_change).toFixed(2)
    },
  },
  created() {
    // Refresh fiat conversion values every minute
    if (this.network.coinGeckoDenom) {
      this.$store.dispatch('fiat/update')
      setInterval(() => {
        this.$store.dispatch('fiat/update')
      }, 60000)
    }
  },
}
</script>
