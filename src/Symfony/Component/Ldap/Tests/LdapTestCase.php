<?php

namespace Symfony\Component\Ldap\Tests;

class LdapTestCase extends \PHPUnit_Framework_TestCase
{
    protected function setUp()
    {
        $this->markTestSkipped('deactivated during pipeline testing');
    }

    protected function getLdapConfig()
    {
        return array(
            'host' => getenv('LDAP_HOST'),
            'port' => getenv('LDAP_PORT'),
        );
    }
}
