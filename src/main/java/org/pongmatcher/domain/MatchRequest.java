package org.pongmatcher.domain;

import javax.persistence.*;

@Entity
public final class MatchRequest {

    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator="match_request_id_seq")
    @SequenceGenerator(name="match_request_id_seq", sequenceName="match_request_id_seq", allocationSize=1)
    @Id
    private volatile Long id;

    private volatile String uuid;

    private volatile String requesterId;

    MatchRequest() {
    }

    public MatchRequest(String uuid, String requesterId) {
        this.uuid = uuid;
        this.requesterId = requesterId;
    }

    public String getUuid() {
        return uuid;
    }

    public String getRequesterId() {
        return requesterId;
    }

}
