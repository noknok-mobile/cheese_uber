<?php

/*
 * Сущность для хранения токенов пользователей
 */

namespace Simbirsoft\Mobile;

use Bitrix\Main\Entity;

/**
 * Сущность для хранения токенов пользователей
 *
 * @author rodial
 */
class MobileTokenTable extends Entity\DataManager
{
    const SERVICE_ANDROID = 'FCM';
    const SERVICE_IOS = 'APNS';

    public static function getTableName() {
        return 'simbirsoft_mobile_mobile_token';
    }

    public static function getUfId() {
        return 'SIM_MOB_MT';
    }

    public static function getMap() {
        return [
            new Entity\IntegerField('ID', [
                'primary' => true,
                'autocomplete' => true
            ]),
            new Entity\IntegerField('UID', ['required' => false]),
            new Entity\StringField('TOKEN', ['required' => true]),
            new Entity\StringField('SERVICE', ['required' => true]),
            new Entity\DatetimeField('CREATED_DATE'),
        ];
    }

    static public function setTokenForUser($token, $service, $user_id = false) {
        if (!$user_id) {
            global $USER;
            $user_id = $USER->getId();
        }

        if ($service != self::SERVICE_IOS && $service != self::SERVICE_ANDROID) {
            $service = self::SERVICE_ANDROID;
        }

        $result = self::getList([
            'filter' => [
                'TOKEN' => $token
            ]
        ]);

        if ($row = $result->fetch()) {
            $row['TOKEN'] = $token;
            if ($user_id > 0)
                $row['UID'] = $user_id;
            $result = self::update($row['ID'], $row);
        } else {
            $result = self::add([
                'UID' => $user_id,
                'TOKEN' => $token,
                'SERVICE' => $service,
                'CREATED_DATE' => new \Bitrix\Main\Type\DateTime(),
            ]);
        }

        if ($result->isSuccess()) {
            return $result->getId();
        } else {
            return false;
        }
    }

    static public function deleteAllForUser($service, $user_id = false) {
        if (!$user_id) {
            global $USER;
            $user_id = $USER->getId();
        }

        $result = self::getList([
            'filter' => [
                '=UID' => $user_id,
                '=SERVICE' => $service,
            ]
        ]);

        while ($row = $result->fetch()) {
            self::delete($row['ID']);
        }

        return true;
    }

    static public function deleteByTokens($tokens) {
        if (!empty($tokens)) {
            $result = self::getList([
                'filter' => [
                    'TOKEN' => $tokens,
                ]
            ]);
            while ($row = $result->fetch()) {
                self::delete($row['ID']);
            }
        }

        return true;
    }

    static public function getTokensForUser($user_id, $service = false) {
        $filter = ['=UID' => $user_id];
        if ($service) {
            $filter['=SERVICE'] = $service;
        }
        $result = self::getList(['filter' => $filter]);
        $tokens = [];
        while ($row = $result->fetch()) {
            $tokens[] = $row;
        }

        if (!empty($tokens)) {
            return $tokens;
        }

        return false;
    }

    static public function getUsersTokens() {
        $result = self::getList(['select' => ['TOKEN','SERVICE']]);
        $tokens = [];
        while ($row = $result->fetch()) {
            $tokens[] = $row;
        }

        if (!empty($tokens)) {
            return $tokens;
        }

        return false;
    }

    static public function setToken($token, $service) {
        if ($service != self::SERVICE_IOS && $service != self::SERVICE_ANDROID) {
            $service = self::SERVICE_ANDROID;
        }
        $result = self::getList([
            'filter' => [
                'TOKEN' => $token,
            ]
        ]);
        if (!$row = $result->fetch()) {
            $results = self::add([
                'TOKEN' => $token,
                'SERVICE' => $service,
                'CREATED_DATE' => new \Bitrix\Main\Type\DateTime(),
            ]);
            if ($results->isSuccess()) {
                return true;
            } else {
                return false;
            }
        } else {
            return true;
        }
    }

}
